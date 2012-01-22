#    This file is part of TuneZombie.
#    Copyright 2012 Greg Lincoln
#
#    TuneZombie is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    TuneZombie is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with TuneZombie.  If not, see <http://www.gnu.org/licenses/>.

require 'parser_helper'
require 'digest'

class Crawler

  def initialize(username)
    @user = User.find_by_name username
    if @user.nil?
      raise "User not found!"
    end
  end

  def crawl()
    # TODO: get paths from config
    path_to_search = '/Volumes/Big/tmp/music'
    path_to_move = '/Volumes/Big/TuneZombie/Music'
    itml_file = '/Volumes/Big/tmp/iml.xml'
    ml = MusicLibrary.new

    # first, see if there is any work to do
    files_to_process =  Dir.glob(path_to_search + '/**/*.m[4p][a3]')
    puts("CRAWL: Using source path [%s], destination path [%s] and iTunes file [%s]." %
             [path_to_search, path_to_move, itml_file])
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
          track = add_track_with_itunes_data(fil, ml.library[key[0]])
          puts("[%s]: Track added!" % b_fil)
        elsif key.count == 0
          puts("[%s]: could not find in library." % b_fil)
          #TODO fallback to taglib
          return
        elsif key.count > 1
          puts("[%s]: found more than once in library." % b_fil)
          #TODO fallback to taglib to find best match in library
          return
        end
        move_file_based_on_metadata(fil, path_to_move, track)

      end
    else
      puts("CRAWL: Nothing to do.")
    end

    # File.basename(file)
  end

  private

  def hash_file(file_name)
    file_h = Digest::SHA2.new
    File.open(file_name, 'r') do |fh|
      while buffer = fh.read(1024)
        file_h << buffer
      end
    end
    file_h.to_s
  end

  def move_file_based_on_metadata(fil, dest_path, track)
    full_dest_path = File.join(dest_path, track.file_path)
    puts("CRAWL: Moving file to [%s]." % full_dest_path)
    FileUtils.mkpath(File.dirname(full_dest_path))
    File.rename(fil, full_dest_path)
  end

  def add_track_with_itunes_data(fil, track)
    file_hash = hash_file(fil)

    dbt = Track.find_or_create_by_file_hash(file_hash)
    new_track = dbt.new_record?

    dbt.comments = track[:comments]
    dbt.date_added = track[:date_added]
    dbt.disc = track[:disc_number]
    dbt.filename = File.basename(fil)
    dbt.name = track[:name]
    dbt.number = track[:track_number]
    dbt.size = track[:size]
    dbt.track_type = track[:kind]
    dbt.save

    tm = TrackMetadata.find_or_create_by_user_and_track(@user, dbt)

    tm.play_count = track[:play_count] || 0
    tm.rating = (track[:rating].to_i || 0) / 20
    tm.skip_count = track[:skip_count] || 0
    tm.save

    # add plays records
    if new_track
      tm.play_count.times do
        play = dbt.track_plays.create
        play.user = @user
        play.played_at = track[:play_date_utc]
        play.save
      end
    else
      puts("Track already present, skipping track_plays gen.")
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

    dbt

  end
end