class HomeController < ApplicationController
  skip_before_filter :authorize, only: [:index]

  def index
    if current_user
      @ratings = current_user.ratings.order("created_at DESC").limit(10)
      unless @ratings.empty? or nil
        @predictions = Prediction.get_unrated_predictions(current_user)
      end
    else
      @tracks = Track.order("average_rating DESC").limit(10)
    end
  end
end
