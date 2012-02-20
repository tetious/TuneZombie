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
  belongs_to :composer, :class_name => "Artist"
  belongs_to :genre
  belongs_to :album
  has_many :track_plays, dependent: :destroy

  def file_path

    "%s/%s/%s/%s" % [MUSIC_FOLDER,
                     self.artist.try_chain(:name, :space_to_underscore, :sanitize_for_filename) || '__nil__',
                     self.album.try_chain(:name, :space_to_underscore, :sanitize_for_filename) || '__nil__',
                     self.filename]

  end

  def file_size
    File.size(file_path)
  end

  def track_name
    "#{number}. #{name}"
  end

  def time
    Time.at(length).strftime("%M:%S")
  end

  def rating
    metadata = TrackMetadata.find_or_create_by_user_and_track(User.current, self)
    metadata.rating
  end

  def rating=(value)
    tm = TrackMetadata.find_or_create_by_user_and_track(User.current, self)
    tm.rating = value
    tm.save
  end

  def album_name
    album.name
  end

  def artist_name
    artist.name
  end

  def mime_type
    "audio/#{file_ext}"
  end

  def file_ext
    File.extname(filename)[1,3]
  end

  def as_json(options={})
    super(options.merge(methods: [:file_ext, :rating]))
  end

  validates :name, :filename, :presence => true
end
