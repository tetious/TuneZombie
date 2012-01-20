class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|

      t.string :type
      t.integer :size
      t.integer :play_count
      t.string :file_url
      t.string :name
      t.integer :number
      t.integer :disc
      t.datetime :date
      t.text :comments
      t.integer :rating

      t.timestamps
    end
  end
end
