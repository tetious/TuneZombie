class TrackPlay < ActiveRecord::Base
  belongs_to :track
  belongs_to :user

  validates :user_id, :track_id, :presence => true
end
