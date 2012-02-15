class CreatePredictions < ActiveRecord::Migration
  def change
    create_table :predictions do |t|
      t.integer :user_id
      t.integer :track_id
      t.integer :value

      t.timestamps
    end
  end
end
