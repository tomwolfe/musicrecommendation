class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.string  :name
      t.string  :artist_name
      t.float   :average_rating

      t.timestamps
    end
  end
  
  def self.down
    drop_table :tracks
  end
end
