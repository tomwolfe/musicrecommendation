class User < ActiveRecord::Base
  has_many :ratings, dependent: :destroy
  has_many :rated_tracks, :through => :ratings, :source => :tracks
  has_secure_password
  
  attr_accessible :email, :password, :password_confirmation
  
  validates_uniqueness_of :email
end
