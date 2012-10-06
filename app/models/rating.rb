class Rating < ActiveRecord::Base
  attr_accessible :value
  after_save :generate_predictions

  belongs_to :track
  belongs_to :user
  
  private
  def generate_predictions
    Prediction.generate_predictions
  end
  
end
