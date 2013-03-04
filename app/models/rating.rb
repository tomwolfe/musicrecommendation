class Rating < ActiveRecord::Base
	attr_accessible :value, :track_id
	after_save :average_rating, :generate_predictions

	# .includes should solve the N+1 problem in the view http://guides.rubyonrails.org/active_record_querying.html#eager-loading-associations
	scope :rated, includes(:track).where("value IS NOT NULL").select("id, user_id, track_id, value, prediction, updated_at, abs(prediction-value) AS difference")
	scope :unrated, includes(:track).where("value IS NULL")

	belongs_to :track
	belongs_to :user
	
	validates :track_id, presence: true
	validates :user_id, presence: true
	validates :value, inclusion: { in: (1..5).to_a << nil }

	def generate_predictions(iterations=10, num_features = 5, regularization = 1)
		@user_count, @track_count = User.count, Track.count
		ratings = Rating.select([:user_id, :track_id, :value]).where("value IS NOT NULL")
		
		# tradeoff between performance/space/complexity. for now User/Track cannot be destroyed w/o breaking predictions
		#		alternate solution https://github.com/tomwolfe/musicrecommendation/commit/ebd68d29f34d6da2c7b1ca6dc4b201399aa87423#app/models/rating.rb
		#		hashes id => index
		rating_table = build_rating_table(ratings)
		calc = CofiCost.new(rating_table, num_features, regularization, iterations, nil, nil)
		calc.min_cost
		@predictions = calc.predictions
		add_predictions
	end
	
	def build_rating_table(ratings)
		rating_table = NArray.float(@user_count,@track_count).fill(0.0)
		# (implemented before I understood that hashes had O(1) lookup time vs users.index(rating.user_id) which is O(n))
		ratings.each do |rating|
			rating_table[rating.user_id-1, rating.track_id-1] = rating.value
		end
		rating_table
	end
	
	def add_predictions
		# would like to use .select but that returns read-only objects
		@ratings = Rating.all
		@ratings.each do |rating|
			@rating = rating
			add_prediction_logic
		end
	end

	def add_prediction(value)
		# Rails v4 FIXME: @rating.update_columns(hash)
		# where: hash = { prediction: value }
		@rating.update_column(:prediction, value)
	end
	
	def add_prediction_logic
		i, j = @rating.user_id-1, @rating.track_id-1
		if @rating.prediction.respond_to?(:-) # lol smiley face
			# only change the prediction if it's changed by more than 0.2
			# (should reduce DB updates)
			unless (@rating.prediction - @predictions[i,j]).abs.between?(0,0.2)
				add_prediction(@predictions[i,j])
			end
		else # prediction is nil
			add_prediction(@predictions[i,j])
		end
	end

	def self.create_empty_ratings(user_or_track = "Track", id_of_track_or_user)
		class_name = user_or_track.to_s.classify.constantize
		class_name.count.times do |i|
			# config/initializers/without_callback.rb
			Rating.without_callback(:save, :after, :generate_predictions) do
				if user_or_track =~ /^Track/
					Rating.create({user_id: id_of_track_or_user, track_id: i+1}, without_protection: true)
				else
					Rating.create({user_id: i+1, track_id: id_of_track_or_user}, without_protection: true)
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
end
