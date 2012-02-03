class Rating < ActiveRecord::Base
  attr_accessible :value

  belongs_to :track
  belongs_to :user
end
