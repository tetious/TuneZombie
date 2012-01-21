class RemoveUserMetadataFromTracks < ActiveRecord::Migration
  def up
    remove_column :tracks, :play_count
    remove_column :tracks, :rating
  end

  def down
    add_column :tracks, :play_count
    add_column :tracks, :rating
  end
end
