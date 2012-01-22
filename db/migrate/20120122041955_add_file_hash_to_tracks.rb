class AddFileHashToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :file_hash, :string

  end
end
