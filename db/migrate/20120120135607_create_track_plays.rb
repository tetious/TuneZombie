class CreateTrackPlays < ActiveRecord::Migration
  def change
    create_table :track_plays do |t|
      t.datetime :played_at

      t.timestamps
    end
  end
end
