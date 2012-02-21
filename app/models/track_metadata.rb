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

class TrackMetadata < ActiveRecord::Base
  belongs_to :user
  belongs_to :track

  def TrackMetadata.find_or_create_by_user_and_track(user, track)

    tm = TrackMetadata.where(user_id: user, track_id: track)
    if tm.empty?
      tm = TrackMetadata.create(user: user, track: track, rating: 0)
    else
      tm.first
    end
  end

  validates :user_id, :track_id, :presence => true
end
