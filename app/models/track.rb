class Track < ActiveRecord::Base
  belongs_to :artist
  belongs_to :composer, :class_name => "Artist"
  belongs_to :genre
  belongs_to :album
  has_many :track_plays, dependent: :destroy

  validates :name, :file_url, :presence => true
end
