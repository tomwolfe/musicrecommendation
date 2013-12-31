class CreatePredictions < ActiveRecord::Migration
  def change
    create_table :predictions do |t|
      t.float :value
      t.references :rating, index: true

      t.timestamps
    end
    Rating.all.each do |r|
      r.create_prediction(:value => r.prediction)
    end
  end
end
