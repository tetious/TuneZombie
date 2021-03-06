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

class Album < ActiveRecord::Base
  has_many :tracks
  validates :name, :presence => true
  searchable_as :al
  searchable_columns name: 'n'

  def art_url
    if self.art_type
      "#{Settings.music_folder}/.__TZAlbumArt__/#{self.id}.#{self.art_type}"
    else
      nil
    end
  end

  def art_mime_type
    "image/#{ art_type }" if self.art_type 
  end

  def artist_name
    self.tracks.first.try_chain(:artist, :name)
  end

  def as_json(options={})
    super(options.merge(:include => {
      :tracks => { 
        :methods => [:rating, :file_ext, :time], 
        :only => [:id, :name, :number, :disc, :album_id, :track_id]
        }
      },
      :methods => :artist_name,
      :only => [:id, :name]
      )
    )
  end
end
