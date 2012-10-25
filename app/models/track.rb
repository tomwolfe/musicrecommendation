class Track < ActiveRecord::Base
  has_many :ratings
  has_many :raters, :through => :ratings, :source => :users
end
