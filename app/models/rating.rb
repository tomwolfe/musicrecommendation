class Rating < ActiveRecord::Base
  attr_accessible :value, :track_id
  after_save :average_rating, :generate_predictions

  belongs_to :track
  belongs_to :user
  
  # for testing so the number of iterations can be stubbed to run only once
  def self.iterate
    10
  end
  
  def generate_predictions(iterations=Rating.iterate, num_features = 5, lambda = 1)
    users = User.pluck(:id)
    tracks = Track.pluck(:id)
    ratings = Rating.all
    rating_table = NArray.float(users.size,tracks.size).fill(0.0)
    
    # OPTIMIZE: save these hashes to the database using rails serialize so the hash does not need to be rebuilt each time.
    users_hash = hash_id_index(users)
    tracks_hash = hash_id_index(tracks)
    
    # (implemented before I understood that hashes had O(1) lookup time vs users.index(rating.user_id) which is O(n))
    ratings.each do |rating|
      rating_table[users_hash[rating.user_id], tracks_hash[rating.track_id]] = rating.value
    end
    
    calc = CofiCost.new(rating_table, num_features, lambda, iterations, nil, nil)
    calc.min_cost
    predictions = calc.predictions
    add_predictions(predictions, users_hash, tracks_hash, users, tracks)
  end
  
  private
  def average_rating
    track.update_attributes average_rating: track.ratings.average(:value)
  end
  
  def hash_id_index(objects)
    hash = Hash.new
    objects.each_index do |i|
      hash[objects[i]] = i
    end
    hash
  end
  
  def add_predictions(predictions, users_hash, tracks_hash, users, tracks)
    # avoid endless loop of callbacks
    Rating.skip_callback(:save, :after, :generate_predictions)
    users.each_index do |i|
      tracks.each_index do |j|
        rating = Rating.find_or_initialize_by_user_id_and_track_id(users_hash.key(i), tracks_hash.key(j))
        unless rating.prediction.equal? predictions[i,j]
          rating.prediction = predictions[i,j]
          rating.save
        end
      end
    end
  end
end
