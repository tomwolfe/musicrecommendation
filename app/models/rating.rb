class Rating < ActiveRecord::Base
  attr_accessible :value, :track_id
  after_save :average_rating, :generate_predictions

  belongs_to :track
  belongs_to :user
  
  validates :track_id, presence: true
  validates :user_id, presence: true
  
  def generate_predictions(iterations=10, num_features = 5, lambda = 1)
    @user_count, @track_count = User.count, Track.count
    ratings = Rating.select([:user_id, :track_id, :value]).where("value IS NOT NULL")
    
    # tradeoff between performance/space/complexity. for now User/Track cannot be destroyed w/o breaking predictions
    #   alternate solution https://github.com/tomwolfe/musicrecommendation/commit/ebd68d29f34d6da2c7b1ca6dc4b201399aa87423#app/models/rating.rb
    #   hashes id => index
    rating_table = build_rating_table(ratings)
    calc = CofiCost.new(rating_table, num_features, lambda, iterations, nil, nil)
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
    # avoid endless loop of callbacks
    Rating.skip_callback(:save, :after, :generate_predictions)
    # OPTIMIZE: might be better to store all ratings (Rating.select(:prediction))
    #  in memory if Rating.count == @user_count * @track_count rather than doing
    #  a bunch of DB lookups.
    @user_count.times do |i|
      @track_count.times do |j|
        @rating = Rating.find_or_initialize_by_user_id_and_track_id(i+1, j+1)
        add_prediction_logic(i,j)
      end
    end
  end
  
  private
  def add_prediction(value)
  	@rating.prediction = value
  	@rating.save
  end
  
  def add_prediction_logic(i,j)
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
  
  def average_rating
    track.update_attributes({average_rating: track.ratings.average(:value)}, without_protection: true)
  end
end
