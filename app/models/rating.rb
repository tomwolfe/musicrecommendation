class Rating < ActiveRecord::Base
	after_save :average_rating, :generate_predictions

	# .includes should solve the N+1 problem in the view http://guides.rubyonrails.org/active_record_querying.html#eager-loading-associations
        # cannot use .includes with .select thus cannot get abs(ratings.value-prediction.value) AS difference...
	scope :rated, -> { includes(:track, :prediction).where.not(ratings: {value: nil}) }
	scope :unrated, -> { includes(:track, :prediction).where(ratings: {value: nil}) }

	belongs_to :track
	belongs_to :user
        has_one :prediction
	
	validates :track_id, presence: true
	validates :user_id, presence: true
	validates :value, inclusion: { in: (1..5).to_a << nil }


	def self.create_empty_ratings(user_or_track = "Track", id_of_track_or_user)
		class_name = user_or_track.to_s.classify.constantize
		class_name.count.times do |i|
			# config/initializers/without_callback.rb
			Rating.without_callback(:save, :after, :generate_predictions) do
				if user_or_track =~ /^Track/
					# prediction should be the average of that track for new users without ratings
					r = Rating.create(user_id: id_of_track_or_user, track_id: i+1)
                                        r.create_prediction(value: Track.find(i+1).average_rating)
				else
					r = Rating.create(user_id: i+1, track_id: id_of_track_or_user)
                                        r.create_prediction
				end
			end
		end
	end

	def average_rating
		# Rails v4 fixme: will be update_columns(hash)
		# where: hash = { average_rating: track.ratings.average(:value) }
		track.average_rating = track.ratings.average(:value)
		track.save(validate: false)
	end

        private
        def generate_predictions
          self.prediction.generate_predictions
        end
end
