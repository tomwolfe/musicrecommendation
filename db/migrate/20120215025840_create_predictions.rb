class CreatePredictions < ActiveRecord::Migration
  def change
    create_table :predictions do |t|
      t.integer :user_id
      t.integer :track_id
      t.float   :value

      t.timestamps
    end
  end
end
