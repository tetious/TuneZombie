class Artist < ActiveRecord::Base
  has_many :tracks
  has_many :composed_tracks, :class_name => "Track"
  validates :name, :presence => true
end
