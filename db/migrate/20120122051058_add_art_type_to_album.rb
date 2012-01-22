class AddArtTypeToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :art_type, :string

  end
end
