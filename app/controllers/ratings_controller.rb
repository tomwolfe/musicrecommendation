class RatingsController < ApplicationController
  #skip_before_filter :authorize, only: [:index]
  
  def destroy
    @rating = Rating.find(params[:id])
    @rating.destroy
    flash[:notice] = "Rating deleted."
    respond_to do |format|
      format.html { redirect_to ratings_path }
      format.json { head :no_content }
    end
  end

end
