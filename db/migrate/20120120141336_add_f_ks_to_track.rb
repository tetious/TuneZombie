class AddFKsToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :artist_id, :int

    add_column :tracks, :album_id, :int

    add_column :tracks, :genre_id, :int

    add_column :tracks, :composer_id, :int

  end
end
