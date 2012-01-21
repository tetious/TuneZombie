class AddDatesToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :date_added, :datetime

  end
end
