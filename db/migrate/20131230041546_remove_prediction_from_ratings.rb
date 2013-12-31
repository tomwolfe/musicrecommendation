class RemovePredictionFromRatings < ActiveRecord::Migration
  def change
    remove_column :ratings, :prediction, :float
  end
end
