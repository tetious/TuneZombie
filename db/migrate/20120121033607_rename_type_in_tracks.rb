class RenameTypeInTracks < ActiveRecord::Migration
  def up
    rename_column :tracks, :type, :track_type
  end

  def down
    rename_column :tracks, :track_type, :type
  end
end
