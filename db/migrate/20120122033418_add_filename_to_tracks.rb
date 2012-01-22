class AddFilenameToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :filename, :string

  end
end
