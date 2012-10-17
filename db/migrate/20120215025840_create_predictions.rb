class CreatePredictions < ActiveRecord::Migration
  def change
    create_table :predictions do |t|
      t.integer :user_id
      t.integer :track_id
      t.float   :value

      t.timestamps
    end
    add_index :predictions, :user_id
    add_index :predictions, :track_id
  end
end
