class Track < ActiveRecord::Base
  has_many :ratings
  has_many :predictions
  has_many :raters, :through => :ratings, :source => :users
  
  def average_rating
    self.ratings.average("value")
  end
end
