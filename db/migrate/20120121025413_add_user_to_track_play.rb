class AddUserToTrackPlay < ActiveRecord::Migration
  def change
    add_column :track_plays, :user_id, :integer

  end
end
