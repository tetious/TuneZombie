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

require 'mp4info'
require 'taglib'
require 'chronic_duration'

class TagM4a

  attr_accessor :art_type

  def initialize(filename)
    @filename = filename
  end

  def tag_type
    'm4a'
  end

  def load
    @tag = MP4Info.open(@filename)

    self
  end

  def disc
    @tag.DISK.try(:first)
  end

  def composer
    @tag.WRT
  end

  def genre
    @tag.GNRE
  end

  def number
    @tag.TRKN.try(:first)
  end

  def track
    @tag.NAM
  end

  def length
    ChronicDuration::parse(@tag.TIME)
  end 

  def artist
    @tag.ART
  end

  def album
    @tag.ALB
  end

  def save_art_to_path(path)
    if @tag.COVR.nil?
      return nil
    else
      header = @tag.COVR[0..10]
      case
        when header.include?('JFIF')
          @art_type = 'jpg'
          path += 'jpg'
        when header.include?('PNG')
          @art_type = 'png'
          path += 'png'
        else
          return nil
      end
    end

    fil = File.open(path, "wb")
    fil.write(@tag.COVR)
    fil.close

    path
  end
end

class TagMp3

  attr_accessor :art_type

  def initialize(filename)
    @filename = filename
  end

  def tag_type
    'mp3'
  end

  def load
    @file = TagLib::MPEG::File.new(@filename)
    @tag = @file.id3v2_tag
    self
  end

  def disc # looks like this "1/5"
    disc = @tag.frame_list('TPOS').first.to_s.split("/").first.to_i
    disc == 0 ? nil : disc
  end

  def composer
    composer = @tag.frame_list('TCOM').first.to_s
    composer == "" ? nil : composer
  end

  def genre
    @tag.genre == "" ? nil : @tag.genre
  end

  def track
    @tag.title == "" ? nil : @tag.title
  end

  def number
    @tag.track == 0 ? nil : @tag.track
  end
  
  def length
    @file.audio_properties.length
  end 

  def artist
    @tag.artist
  end

  def album
    @tag.album
  end

  def save_art_to_path(path)
    if @tag.frame_list('APIC').first.nil?
      puts "No APIC tag found."
      return nil
    else
      apic = @tag.frame_list('APIC').first

      case apic.mime_type
        when 'image/jpeg', 'image/jpg'
          @art_type = 'jpg'
          path += 'jpg'
        when 'image/png'
          @art_type = 'png'
          path += 'png'
        else
          puts "Invalid mime type: #{apic.mime_type}"
          return nil
      end
    end

    puts "Saving art to path: #{path}"
    fil = File.open(path, "wb")
    fil.write(apic.picture)
    fil.close

    path
  end

end

# current taglib doesn't support mp4, so use mp4info instead
class TagHelper

  def self.create(filename)
    case File.extname(filename)
      when '.m4a'
        TagM4a.new(filename).load
      when '.mp3'
        TagMp3.new(filename).load
      else
        nil
    end
  end

end