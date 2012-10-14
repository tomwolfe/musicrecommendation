class Rating < ActiveRecord::Base
  attr_accessible :value, :track_id
  after_save :generate_predictions, :average_rating
  
  validates :value, numericality: {less_than_or_equal_to: 5, greater_than_or_equal_to: 0}
  validates :value, presence: true

  belongs_to :track
  belongs_to :user
  
  private
  def generate_predictions
    Prediction.generate_predictions
  end
  
  def average_rating
    self.track.average_rating = self.track.ratings.average('value')
  end
  
end
