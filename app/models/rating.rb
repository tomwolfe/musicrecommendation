class Rating < ActiveRecord::Base
  attr_accessible :value
  after_save Prediction.generate_predictions

  belongs_to :track
  belongs_to :user
  
end
