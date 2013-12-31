class Prediction < ActiveRecord::Base
  belongs_to :rating

  def generate_predictions(iterations = 10, num_features = 10, regularization = 0.3)
    @user_count, @track_count = User.count, Track.count
    ratings = Rating.select([:user_id, :track_id, :value]).where("value IS NOT NULL")
    
    # tradeoff between performance/space/complexity. for now User/Track cannot be destroyed w/o breaking predictions
    #		alternate solution https://github.com/tomwolfe/musicrecommendation/commit/ebd68d29f34d6da2c7b1ca6dc4b201399aa87423#app/models/rating.rb
    #		hashes id => index
    rating_table = build_rating_table(ratings)
    calc = CofiCost.new(rating_table, num_features, regularization, iterations, 5, 0, nil, nil)
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
    ratings = Rating.includes(:prediction).all
    ratings.each do |rating|
      @rating = rating
      add_prediction_logic
    end
  end
  
  def add_prediction_logic
    i, j, prediction = @rating.user_id-1, @rating.track_id-1, @rating.prediction.value
    if prediction.respond_to?(:-) # lol smiley face
      # only change the prediction if it's changed by more than 0.2
      # (should reduce DB updates)
      unless (prediction - @predictions[i,j]).abs.between?(0,0.2)
        @rating.prediction.update(:value => @predictions[i,j])
      end
    else # prediction is nil
      @rating.prediction.update(:value => @predictions[i,j])
    end
  end
end
