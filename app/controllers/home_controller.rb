class HomeController < ApplicationController
  skip_before_filter :authorize, only: [:index]

  # FIXME: separate index actions for logged_in and not_logged_in users (action cache for logged in/page cache for not_logged_in)
  def index
    if current_user
      # FIXME: in the home view we access the artist_name/etc of each ratings track.
      # this is the N+1 problem http://guides.rubyonrails.org/active_record_querying.html#eager-loading-associations
      # maybe current_user.ratings.includes(:track).where(blah).order(blah).limit(10)
      # I'll test this later...
      # FIXME: index columns that sorts/orders are done on
      @ratings = current_user.ratings.where("value IS NOT NULL").order("created_at DESC").limit(10)
      @unrated_predictions = current_user.ratings.where("value IS NULL").select("id, user_id, track_id, value, prediction, created_at, updated_at, abs(prediction-value) AS difference").order("prediction DESC").limit(10)
    else
      @tracks = Track.order("average_rating DESC").limit(10)
    end
  end
end
