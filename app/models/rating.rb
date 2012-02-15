class Rating < ActiveRecord::Base
  attr_accessible :value
  after_save :generate_predictions

  belongs_to :track
  belongs_to :user
  
  def generate_predictions
    users = User.select(:id)
    tracks = Track.select(:id)
    ratings = Rating.all
    rating_table = NArray.float(users.size,tracks.size).fill(0.0)
    
    users_hash = hash_id_index(users)
    tracks_hash = hash_id_index(tracks)
    
    ratings.each do |rating|
      rating_table[users_hash[rating.user_id],tracks_hash[rating.track_id]] = rating.value
    end
    
    num_features = 5
    lambda = 1
    iterations = 10
    
    calc = CofiCost.new(rating_table, num_features, lambda, iterations, nil, nil)
    calc.min_cost
    predictions = calc.predictions
    add_predictions(predictions, users_hash, tracks_hash, users, tracks)
  end
  
  def hash_id_index(objects)
    hash = Hash.new
    objects.each_index do |i|
      hash[objects[i].id] = i
    end
    hash
  end
  
  def add_predictions(predictions, users_hash, tracks_hash, users, tracks)
    users.each_index do |i|
      tracks.each_index do |j|
        predict = Prediction.find_or_initialize_by_user_id_and_track_id(users_hash.key(i), tracks_hash.key(j))
        if predict.value.equal? predictions[i,j]
        else
          predict.value = predictions[i,j]
          predict.save
        end
      end
    end
  end
  
end
