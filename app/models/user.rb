class User < ActiveRecord::Base
	has_many :ratings, dependent: :destroy
	has_many :rated_tracks, :through => :ratings, :source => :tracks
	# same as FIXME in Track model
	# after_create {|user| Rating.create_empty_ratings("Track", user.id)}
	after_create :create_empty_ratings
	has_secure_password validations: false # Rails bug: https://github.com/rails/rails/pull/11107#issuecomment-21850919
	
	validates :password, confirmation: true, length: { in: 6..30 }, presence: true
	validates :email, uniqueness: true, format: { with: /\A\S+@\S+\.\S+\z/, message: "Probably not a valid email regex" }

	def create_empty_ratings
		Rating.create_empty_ratings("Track", self.id)
	end

end
