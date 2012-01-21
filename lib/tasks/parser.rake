require 'parser_helper'

namespace :tz do
  desc "Find new media to load"
  task :media, [:username] => :environment do |t, args|
    c = Crawler.new(args.username)
    c.crawl
  end
end

class Crawler

  def initialize(username)
    @user = User.find_by_name username
    if @user.nil?
      raise "User not found!"
    end
  end

  def crawl()
    # TODO: get paths from config
    path_to_search = '/Volumes/Big/tmp/music/'
    itml_file = '/Volumes/Big/tmp/iml.xml'
    ml = MusicLibrary.new

    # first, see if there is any work to do
    files_to_process =  Dir.glob(path_to_search + '**/*.m[4p][a3]')
    puts("CRAWL: Using path [%s] and iTunes file [%s]." % [path_to_search, itml_file])
    if files_to_process.count > 0
      # load the library file

      puts("CRAWL: [%s] files to process this run." % files_to_process.count)
      puts("CRAWL: Loading iTunes library file. (This may take a while.)")
      ml.load(itml_file)
      puts("CRAWL: iTunes library file loaded.")

      files_to_process.each do |fil|
        puts("CRAWL: Attempting to add file [%s]" % fil)
        b_fil = ml.clean_filename(fil)
        # see if we can find track data for it
        key = ml.library.keys.select { |f| f.start_with?(b_fil) }
        if key.count == 1
          # hooray
          add_track_with_data(fil, ml.library[key[0]])
          puts("[%s]: Track added!" % b_fil)
        elsif key.count == 0
          puts("[%s]: could not find in library." % b_fil)
          #TODO fallback to taglib
        elsif key.count > 1
          puts("[%s]: found more than once in library." % b_fil)
          #TODO fallback to taglib to find best match in library
        end

      end
    else
      puts("CRAWL: Nothing to do.")
    end

    # File.basename(file)
  end

  private

  def add_track_with_data(fil, track)
    dbt = Track.find_or_create_by_file_url fil
    existing_track = dbt.id?

    dbt.comments = track[:comments]
    dbt.date_added = track[:date_added]
    dbt.disc = track[:disc_number].to_i
    dbt.file_url = fil
    dbt.name = track[:name]
    dbt.number = track[:track_number]
    dbt.size = track[:size]
    dbt.track_type = track[:kind]
    dbt.save

    tm = TrackMetadata.find_or_create_by_user_and_track(@user, dbt)

    tm.play_count = track[:play_count].nil? ? 0 : track[:play_count]
    tm.rating = track[:rating].nil? ? 0 : track[:rating].to_i / 20
    tm.save

    # add plays records
    if existing_track
      puts("Track already present, skipping track_plays gen.")
    else
      tm.play_count.times do
        play = dbt.track_plays.create
        play.user = @user
        play.played_at = track[:play_date_utc]
        play.save
      end
    end

    # set/add album
    if track.has_key?(:album)
      album = Album.find_or_create_by_name(track[:album])
      dbt.album = album
      # TODO: something clever with artwork
    end

    # set/add artist
    if track.has_key?(:artist)
      artist = Artist.find_or_create_by_name(track[:artist])
      dbt.artist = artist
    end
    # set/add composer
    if track.has_key?(:composer)
      composer = Artist.find_or_create_by_name(track[:composer])
      dbt.composer = composer
    end

    # set/add genre
    if track.has_key?(:genre)
      genre = Genre.find_or_create_by_name(track[:genre])
      dbt.genre = genre
    end

    dbt.save

  end
end
