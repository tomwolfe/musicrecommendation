class User < ActiveRecord::Base
	has_many :ratings, dependent: :destroy
	has_many :rated_tracks, :through => :ratings, :source => :tracks
	# same as FIXME in Track model
	# after_create {|user| Rating.create_empty_ratings("Track", user.id)}
	after_create :create_empty_ratings
	has_secure_password
	
	attr_accessible :email, :password, :password_confirmation
	
	validates_uniqueness_of :email

	def create_empty_ratings
		Rating.create_empty_ratings("Track", self.id)
	end

end
