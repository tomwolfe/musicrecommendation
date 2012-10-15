class HomeController < ApplicationController
  skip_before_filter :authorize, only: [:index]

  def index
    if current_user.nil?
      @tracks = Track.order("average_rating DESC").limit(10)
    else
      @ratings = current_user.ratings.order("created_at DESC").limit(10)
      unless @ratings.empty? or nil
        not_yet_rated_tracks = Track.select("id").where('id not in (?)', current_user.ratings.pluck(:track_id))
        @predictions = current_user.predictions.where('track_id in (?)', not_yet_rated_tracks).order("value DESC").limit(10)
      end
    end
  end
end
