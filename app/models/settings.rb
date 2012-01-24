class Settings < ActiveRecord::Base

  validates :key, presence: true
end
