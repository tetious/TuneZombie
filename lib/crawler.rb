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
    @move_files = options[:move_files]

    FileUtils.mkpath(File.join(@dest_path, '.__TZAlbumArt__'))

    User.current = options[:username]
    raise "User not found!" if User.current.nil?
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
        matched_tracks = ml.library.select { |k,v| k.start_with?(b_fil) }.values
        tag = TagHelper.create(fil)
        if matched_tracks.count >= 1
          library_track = matched_tracks.select { |t| t[:album] == tag.album }

          if library_track.count == 1 # after limiting by artist and album, we have a match!
            puts "[#{b_fil}]: found in iTunes library."
            track = add_track_with_itunes_data(fil, library_track.first)
          elsif library_track.count > 1 # after limiting, we still have more than one match.
            puts "[#{b_fil}]: found #{library_track.count} times in iTunes library. Skipping."
          elsif library_track.count == 0 # no matches after filtering
            puts "[#{b_fil}]: could not find in library after filtering."
            track = add_track_with_tag_data(fil, tag)
          end
        elsif matched_tracks.count == 0
          puts "[#{b_fil}]: could not find in library."
          track = add_track_with_tag_data(fil, tag)
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
  end

  private

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

  def map_track_from_tag(db_track, tag)
    db_track.date_added = DateTime.now
    db_track.disc = tag.disc
    db_track.name = tag.track
    db_track.number = tag.number
    db_track.track_type = tag.tag_type
    db_track.length = tag.length

    db_track
  end

  def get_album(options)
    album = Album.find_or_create_by_name options[:album_name]

    if album.new_record? or album.art_type.nil? # keep trying if the art isn't there
      tag = options[:tag_helper] || TagHelper.create(options[:file])
      album.art_type = tag.art_type
      if album.art_url
        tag.save_art_to_path(album.art_url)
        album.save
        puts "get_album: Art saved!"
      end
    end

    album
  end

  def add_track_with_tag_data(fil, tag)
    db_track = Track.track_from_file fil
    map_track_from_tag(db_track, tag)
    db_track.size = File.size(fil)
    db_track.filename = File.basename(fil)
    db_track.save

    db_track.album = get_album album_name: tag.album, tag_helper: tag if tag.album
    db_track.artist = Artist.find_or_create_by_name(tag.artist) if tag.artist
    db_track.composer = Artist.find_or_create_by_name(tag.composer) if tag.composer 
    db_track.genre = Genre.find_or_create_by_name(tag.genre) if tag.genre

    tm = TrackMetadata.find_or_create_by_user_and_track(User.current, db_track)
    tm.save

    db_track.save
    db_track
  end

  def add_track_with_itunes_data(fil, itunes_track)
    db_track = Track.track_from_file fil
    new_track = db_track.new_record?

    map_track_from_itl(db_track, itunes_track)
    db_track.filename = File.basename(fil)

    db_track.save

    tm = TrackMetadata.find_or_create_by_user_and_track(User.current, db_track)

    tm.play_count = itunes_track[:play_count] || 0
    tm.rating = (itunes_track[:rating].to_i || 0) / 20
    tm.skip_count = itunes_track[:skip_count] || 0
    tm.save

    if new_track
      tm.play_count.times do
        play = db_track.track_plays.create
        play.user = User.current
        play.played_at = itunes_track[:play_date_utc]
        play.played_time = db_track.length
        play.save
      end
    else
      puts "ATWID: Track already present, skipping track_plays gen."
    end

    db_track.album = get_album album_name: itunes_track[:album], file: fil if itunes_track.has_key?(:album)
    db_track.artist = Artist.find_or_create_by_name(itunes_track[:artist]) if itunes_track.has_key?(:artist)
    db_track.composer = Artist.find_or_create_by_name(itunes_track[:composer]) if itunes_track.has_key?(:composer)
    db_track.genre = Genre.find_or_create_by_name(itunes_track[:genre]) if itunes_track.has_key?(:genre)

    db_track.save
    db_track
  end
end