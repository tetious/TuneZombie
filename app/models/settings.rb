class Settings < ActiveRecord::Base

  def self.music_folder
    Thread.current[:music_folder] || Settings.find_or_create_by_key("dest_path").value || MUSIC_FOLDER
  end

  validates :key, presence: true
end
