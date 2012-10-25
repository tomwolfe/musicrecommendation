class HomeController < ApplicationController
  skip_before_filter :authorize, only: [:index]

  def index
    if current_user
      @ratings = current_user.ratings.where("value IS NOT NULL").order("created_at DESC").limit(10)
      @unrated_predictions = current_user.ratings.where("value IS NULL").order("prediction DESC").limit(10)
    else
      @tracks = Track.order("average_rating DESC").limit(10)
    end
  end
end
