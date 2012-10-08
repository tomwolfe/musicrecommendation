class RatingsController < ApplicationController
  before_filter :authorize

  def create
    @rating = Rating.new(params[:rating])
    @rating.user_id = current_user.id
    if @rating.save
      respond_to do |format|
        format.html { redirect_to rating_path(@rating), notice: "Rating successfully created" }
        format.js
      end
    else
      render :new
    end
  end
  
  def edit
    @rating = Rating.find(params[:id])
  end
  
  def new
    @rating = Rating.new
  end

  def update
    # I'm not sure if this'll work (track_id in params[:rating] hash?)
    @rating = current_user.ratings.find_by_track_id(params[:rating][:track_id])
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
