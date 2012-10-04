class RatingsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @track = Track.find_by_id(params[:track_id])
    @rating = Rating.new(params[:rating])
    @rating.track_id = @track.id
    @rating.user_id = current_user.id
    if @rating.save
      respond_to do |format|
        format.html { redirect_to track_path(@track), :notice => "Your rating has been saved" }
        format.js
      end
    end
  end

  def edit
    @track = Track.find_by_id(params[:track_id])
    @rating = current_user.ratings.find_by_track_id(@track.id)
    if @rating.update_attributes(params[:rating])
      respond_to do |format|
        format.html { redirect_to track_path(@track), :notice => "Your rating has been updated" }
        format.js
      end
    end
  end

end
