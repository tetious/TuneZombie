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
require 'mp3info'
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

  def art_type
    if @tag.COVR.nil?
      nil
    else
      header = @tag.COVR[0..10]
      case
        when header.include?('JFIF')
          'jpg'
        when header.include?('PNG')
          'png'
        else
          nil
      end
    end
  end

  def save_art_to_path(path)
    fil = File.open(path, "wb")
    fil.write(@tag.COVR)
    fil.close
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
    @file = Mp3Info.open(@filename)
    @tag2 = @file.tag2
    @tag = @file.tag

    @apic = false
    if @tag2['APIC'] 
      @text_encoding, @mime_type, @picture_type, @description, @picture_data = @tag2['APIC'].unpack("c Z* c Z* a*")
      @apic = true 
    end 

    self
  end

  def disc # looks like this "1/5"
    disc = @tag2['TPOS'].to_s.split("/").first.to_i
    disc == 0 ? nil : disc
  end

  def composer
    composer = @tag2['TCOM'].to_s
    composer == "" ? nil : composer
  end

  def genre
    @tag.genre == "" ? nil : @tag.genre_s
  end

  def track
    @tag.title == "" ? nil : @tag.title
  end

  def number
    @tag.track == 0 ? nil : @tag.tracknum
  end
  
  def length
    @file.length
  end 

  def artist
    @tag.artist
  end

  def album
    @tag.album
  end

  def art_type
    if @apic
      case @mime_type
        when 'image/jpeg', 'image/jpg'
          'jpg'
        when 'image/png'
          'png'
        else
          puts "Invalid mime type: #{@mime_type}"
          nil
      end
    else
      puts "No APIC tag found."
      nil
    end
  end

  def save_art_to_path(path)
    if @apic
      puts "Saving art to path: #{path}"
      fil = File.open(path, "wb")
      fil.write @picture_data
      fil.close
    end
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