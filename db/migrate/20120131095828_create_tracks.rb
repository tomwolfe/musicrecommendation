class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.string  :name
      t.string  :artist_name
      t.float   :average_rating
      t.string	:mb_id
      t.string	:releases

      t.timestamps
    end
    # index's for track search
    add_index :tracks, :name
    add_index :tracks, :artist_name
  end
  
  def self.down
    drop_table :tracks
    remove_index :tracks, :name
    remove_index :tracks, :artist_name
  end
end
