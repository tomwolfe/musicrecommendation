class RatingsController < ApplicationController
  #skip_before_filter :authorize, only: [:index]
  
  def create
    @rating = Rating.new(params[:rating])
    @rating.user_id = current_user.id
    respond_to do |format|
    	if @rating.save
		    format.html { redirect_to root_path, notice: "Rating successfully created" }
		    format.js
		  else
		  	format.html { redirect_to root_path, alert: "Unable to create rating" }
		    format.js
		  end
    end
  end
  
  def update
    @rating = current_user.ratings.find_by_id(params[:id])
    respond_to do |format|
    	if @rating.update_attributes(params[:rating])
		    format.html { redirect_to root_path, notice: "Rating successfully updated" }
		    format.js
		  else
		  	format.html { redirect_to root_path, alert: "Unable to update rating" }
		    format.js
		  end
    end
  end
  
  def destroy
    @rating = Rating.find(params[:id])
    @rating.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: "Rating deleted" }
      format.json { head :no_content }
    end
  end
end
