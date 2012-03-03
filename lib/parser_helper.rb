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

require 'uri'
require 'helper_patches'
require 'unicode_utils/nfc'

class MusicLibrary

  attr_accessor :library

  def initialize
    @library = Hash.new
  end

  def load(filename)
    file = open(filename)

    # we're parsing a three level hash, first wraps the whole library,
    # second all tracks, the third wraps a single track
    dict_count = 0 # outside all dicts
    tmp_hash = nil
    file.each_line do |l|

      case
        when l.include?('<dict>')
          dict_count +=1
          if dict_count == 3 && tmp_hash.nil? # first row in a new track dict
            tmp_hash = Hash.new
          end
        when l.include?('</dict>')
          dict_count -=1
          if dict_count == 2 && !tmp_hash.nil? # just leaving the single track dict
            @library[track_key(tmp_hash)] = tmp_hash
            tmp_hash = nil
          end
          break if dict_count == 1
        when dict_count == 3 && l.include?('<key>') # in a track dict
          row_hash = rip_hash(l)
          tmp_hash[row_hash[0]] = row_hash[1]
        else
      end

    end
  end

  def clean_filename(raw_filename)
    UnicodeUtils.nfc(URI.unescape(File.basename(raw_filename)).downcase.space_to_underscore)
  end

  private

  def track_key(track)
    clean_filename(track[:location]) + '~' + track[:track_id]
  end

  def rip_hash(row)
    # ["", "key", "Play Count", "/key", "", "integer", "10", "/integer"]
    # 2 = key, 6 = value

    l = row.split(/[><]/)
    [l[2].downcase.space_to_underscore.to_sym, l[6]]
  end

end
