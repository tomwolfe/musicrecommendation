class RatingsController < ApplicationController
  skip_before_filter :authorize, only: [:index]
  
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
    @rating = current_user.ratings.find_by_id(params[:id])
    if @rating.update_attributes(params[:rating])
      respond_to do |format|
        format.html { redirect_to rating_path(@rating), notice: "Your rating has been updated" }
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
