class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :track_id
      t.integer :value
      t.float   :prediction

      t.timestamps
    end
    
    add_index :ratings, :value
    add_index :ratings, :user_id
    add_index :ratings, :track_id
  end
  
  def self.down
    drop_table :ratings
    remove_index :ratings, :value
    remove_index :ratings, :user_id
    remove_index :ratings, :track_id
  end
end
