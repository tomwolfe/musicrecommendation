class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.string  :name, null: false
      t.string  :artist_name, null: false
      t.float   :average_rating
      t.string	:mb_id, null: false
      t.string	:releases

      t.timestamps
    end
    # index's for track search
    add_index :tracks, :name
    add_index :tracks, :artist_name
		add_index :tracks, :mb_id, unique: true
		add_index :tracks, :updated_at
	end
  
  def self.down
    drop_table :tracks
    remove_index :tracks, :name
    remove_index :tracks, :artist_name
		remove_index :tracks, :mb_id
		remove_index :tracks, :updated_at
  end
end
