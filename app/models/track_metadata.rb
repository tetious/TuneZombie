class TrackMetadata < ActiveRecord::Base
  belongs_to :user
  belongs_to :track

  def TrackMetadata.find_or_create_by_user_and_track(user, track)

    tm = TrackMetadata.find(user: user, track: track)
    if tm.nil?
      tm = TrackMetadata.create
      tm.user = user
      tm.track = track
    end
    tm
  end

  validates :user_id, :track_id, :presence => true
end
