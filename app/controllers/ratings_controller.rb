class RatingsController < ApplicationController
  before_filter :authorize

  def create
    #@track = Track.find_by_id(params[:track_id])
    @rating = Rating.new(params[:rating])
    #@rating.track_id = @track.id
    #@rating.user_id = current_user.id
    if @rating.save
      respond_to do |format|
        format.html { redirect_to track_path(@rating.track_id), notice: "Your rating has been saved" }
        format.js
      end
    else
      render :new
    end
  end
  
  def edit
    @track = Track.find(params[:id])
  end
  
  def new
    @track = Track.new
  end

  def update
    #@track = Track.find_by_id(params[:id])
    @rating = current_user.ratings.find_by_track_id(params[:rating])
    if @rating.update_attributes(params[:rating])
      respond_to do |format|
        format.html { redirect_to track_path(@track), notice: "Your rating has been updated" }
        format.js
      end
    else
      render :edit
    end
  end
  
  def destroy
    @rating = Rating.find(params[:id])
    @rating.destroy
    
    respond_to do |format|
      format.html { redirect_to ratings_path }
      format.json { head :no_content }
    end
  end

end
