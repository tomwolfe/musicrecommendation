class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :track_id
      t.integer :value

      t.timestamps
    end
    
    add_index :ratings, :user_id
    add_index :ratings, :track_id
  end
end
