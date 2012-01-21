class AddFkToTrackPlays < ActiveRecord::Migration
  def change
    add_column :track_plays, :track_id, :int

  end
end
