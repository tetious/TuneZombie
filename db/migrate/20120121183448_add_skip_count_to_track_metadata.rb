class AddSkipCountToTrackMetadata < ActiveRecord::Migration
  def change
    add_column :track_metadata, :skip_count, :integer

  end
end
