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

class Track < ActiveRecord::Base
  belongs_to :artist
  belongs_to :composer, :class_name => 'Artist'
  belongs_to :genre
  belongs_to :album
  has_many :track_plays, :dependent => :destroy
  has_many :track_metadatas, :dependent => :destroy
  validates :name, :filename, :presence => true

  def file_path

    '%s/%s/%s/%s' % [Settings.music_folder,
                     self.artist.try_chain(:name, :space_to_underscore, :sanitize_for_filename) || '__nil__',
                     self.album.try_chain(:name, :space_to_underscore, :sanitize_for_filename) || '__nil__',
                     self.filename]

  end

  def rating
    track_metadata.try(:rating)
  end

  def file_size
    File.size(file_path)
  end

  def track_name
    "#{number}. #{name}"
  end

  def mime_type
    mime_types = {m4a: 'audio/mp4a-latm', mp3: 'audio/mpeg'}
    mime_types[file_ext.to_sym]
  end

  def file_ext
    File.extname(filename)[1,3]
  end

  def self.track_from_file(fil)
    hash = Track.hash_file fil
    Track.find_or_create_by_file_hash hash
  end

  def self.hash_file(file_name)
    file_h = Digest::SHA2.new
    File.open(file_name, 'r') do |fh|
      while (buffer = fh.read(1024))
        file_h << buffer
      end
    end
    file_h.to_s
  end

  private
    def track_metadata
      if User.current
        track_metadatas.where(user_id: User.current).first
      end
    end

end
