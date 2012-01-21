class TrackMetadata < ActiveRecord::Base
  belongs_to :user
  belongs_to :track

  def TrackMetadata.find_or_create_by_user_and_track(user, track)

    tm = TrackMetadata.where(user_id: user, track_id: track)
    if tm.empty?
      tm = TrackMetadata.create(user: user, track: track)
    else
      tm.first
    end
  end

  validates :user_id, :track_id, :presence => true
end
