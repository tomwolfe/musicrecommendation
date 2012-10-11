class HomeController < ApplicationController
  skip_before_filter :authorize, only: [:not_signed_in]

  def signed_in_items
    @ratings = current_user.ratings.order("created_at DESC").limit(10)
    if @ratings.empty? or nil
    else
      not_yet_rated = Track.select("id").where('id not in (?)', current_user.ratings.select("track_id").map(&:track_id)).order("value DESC").limit(10)
    end
  end
  
  def not_signed_in_items
    @ratings = Rating.order("average_rating DESC").limit(10)
  end
end
