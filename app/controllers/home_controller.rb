class HomeController < ApplicationController
	skip_before_filter :authorize, only: [:signedout]

	def signedin
			# .includes should solve the N+1 problem in the view http://guides.rubyonrails.org/active_record_querying.html#eager-loading-associations
			@search = Search.new(params[:search])
			@ratings = current_user.ratings.rated.order(updated_at: :desc).limit(10)
			@unrated_predictions = current_user.ratings.unrated.order("predictions.value DESC").limit(10)
	end

	def signedout
		@tracks = Track.order("average_rating DESC").limit(10)
	end
end
