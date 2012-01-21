class CreateTrackMetadata < ActiveRecord::Migration
  def change
    create_table :track_metadata do |t|
      t.integer :track_id
      t.integer :user_id
      t.integer :play_count
      t.integer :rating

      t.timestamps
    end
  end
end
