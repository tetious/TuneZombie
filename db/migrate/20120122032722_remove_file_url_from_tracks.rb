class RemoveFileUrlFromTracks < ActiveRecord::Migration
  def up
    remove_column :tracks, :file_url
  end

  def down
    add_column :tracks, :file_url, :string
  end
end
