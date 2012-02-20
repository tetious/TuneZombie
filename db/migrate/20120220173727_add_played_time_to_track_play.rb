class AddPlayedTimeToTrackPlay < ActiveRecord::Migration
  def change
    add_column :track_plays, :played_time, :int

  end
end
