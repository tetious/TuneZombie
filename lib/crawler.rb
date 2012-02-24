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
require 'fileutils'
require 'tag_helper'

class Crawler

  def initialize(options = {})
    @path_to_search = options[:path_to_search]
    @dest_path = options[:dest_path]
    @itml_file = options[:itml_file]
    @move_files = options[:move_files] || false

    FileUtils.mkpath(File.join(@dest_path, '.__TZAlbumArt__'))

    @user = User.find_by_name options[:username]
    if @user.nil?
      raise "User not found!"
    end
  end

  #noinspection RubyScope
  def crawl
    ml = MusicLibrary.new

    # first, see if there is any work to do
    files_to_process =  Dir.glob(@path_to_search + '/**/*.m[4p][a3]')
    puts("CRAWL: Using source path [%s], destination path [%s] and iTunes file [%s]." %
             [@path_to_search, @dest_path, @itml_file])
    if files_to_process.count > 0
      # load the library file

      puts "CRAWL: [#{files_to_process.count}] files to process this run." 
      puts "CRAWL: Loading iTunes library file. (This may take a while.)"
      ml.load(@itml_file)
      puts "CRAWL: iTunes library file loaded."

      files_to_process.each do |fil|
        track = nil
        puts "CRAWL: Attempting to add file [#{fil}]"
        b_fil = ml.clean_filename(fil)
        # see if we can find track data for it
        key = ml.library.keys.select { |f| f.start_with?(b_fil) } #TODO: check to see if start_with is valid
        if key.count == 1
          # hooray
          track = add_track_with_itunes_data(fil, ml.library[key[0]])
        elsif key.count == 0
          puts "[#{b_fil}]: could not find in library."
          #TODO fallback to taglib
        elsif key.count > 1
          puts "[#{b_fil}]: found #{key.count} times in library, trying to use tag to narrow it down."

          tag = TagHelper.create(fil)
          matched_tracks = key.map { |k| ml.library[k] }

          puts "Tag artist_name: #{tag.artist_name}."
          puts "Matched artist names: #{matched_tracks.map { |t| t[:artist]}.join ', '}."
          
          library_track = matched_tracks.select { |t| t[:artist] == tag.artist_name }
          puts "Rematched count is #{library_track.count}."
          if library_track.count == 1
            track = add_track_with_itunes_data(fil, library_track.first)
          end

        end

        if track.nil?
          puts "[#{b_fil}]: Skipping track."
        else
          move_file_based_on_metadata(fil, track)
          puts "[#{b_fil}]: Track added!"
        end

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

  def move_file_based_on_metadata(fil, track)
    FileUtils.mkpath(File.dirname(track.file_path))
    if @move_files
      puts "CRAWL: Moving file to #{track.file_path}."
      FileUtils.move(fil, track.file_path)
    else # copy
      puts "CRAWL: Copying file to #{track.file_path}."
      FileUtils.copy(fil, track.file_path)
    end
  end

  def map_track_from_itl(db_track, itunes_track)
    db_track.comments = itunes_track[:comments]
    db_track.date_added = itunes_track[:date_added]
    db_track.disc = itunes_track[:disc_number]
    db_track.name = itunes_track[:name]
    db_track.number = itunes_track[:track_number]
    db_track.size = itunes_track[:size]
    db_track.track_type = itunes_track[:kind]
    db_track.length = itunes_track[:total_time].to_i / 1000

    db_track

  end
  
  def add_track_with_itunes_data(fil, itunes_track)
    file_hash = hash_file(fil)

    db_track = Track.find_or_create_by_file_hash(file_hash)
    new_track = db_track.new_record?

    map_track_from_itl(db_track, itunes_track)
    db_track.filename = File.basename(fil)

    db_track.save

    tm = TrackMetadata.find_or_create_by_user_and_track(@user, db_track)

    tm.play_count = itunes_track[:play_count] || 0
    tm.rating = (itunes_track[:rating].to_i || 0) / 20
    tm.skip_count = itunes_track[:skip_count] || 0
    tm.save

    # add plays records
    if new_track
      tm.play_count.times do
        play = db_track.track_plays.create
        play.user = @user
        play.played_at = itunes_track[:play_date_utc]
        play.save
      end
    else
      puts "ATWID: Track already present, skipping track_plays gen."
    end

    # set/add album
    if itunes_track.has_key?(:album)
      album = Album.find_or_create_by_name(itunes_track[:album])

      if album.new_record? || album.art_type.nil? # keep trying if the art isn't there
        tag = TagHelper.create(fil)
        t_path = tag.save_art_to_path(album.art_url)
        album.art_type = tag.art_type
        album.save
        puts "ATWID: Art saved!"
      end

      db_track.album = album
    end

    # set/add artist
    if itunes_track.has_key?(:artist)
      artist = Artist.find_or_create_by_name(itunes_track[:artist])
      db_track.artist = artist
    end
    # set/add composer
    if itunes_track.has_key?(:composer)
      composer = Artist.find_or_create_by_name(itunes_track[:composer])
      db_track.composer = composer
    end

    # set/add genre
    if itunes_track.has_key?(:genre)
      genre = Genre.find_or_create_by_name(itunes_track[:genre])
      db_track.genre = genre
    end

    db_track.save

    db_track

  end
end