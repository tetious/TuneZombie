class RemoveArtUrlFromAlbum < ActiveRecord::Migration
  def up
    remove_column :albums, :art_url
      end

  def down
    add_column :albums, :art_url, :string
  end
end
