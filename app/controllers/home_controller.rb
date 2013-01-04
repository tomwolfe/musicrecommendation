class HomeController < ApplicationController
	skip_before_filter :authorize, only: [:signedout]

	def signedin
			# .includes should solve the N+1 problem in the view http://guides.rubyonrails.org/active_record_querying.html#eager-loading-associations
			@ratings = current_user.ratings.includes(:track).where("value IS NOT NULL").order("created_at DESC").limit(10)
			@unrated_predictions = current_user.ratings.includes(:track).where("value IS NULL").select("id, user_id, track_id, value, prediction, created_at, updated_at, abs(prediction-value) AS difference").order("prediction DESC").limit(10)
	end

	def signedout
		@tracks = Track.order("average_rating DESC").limit(10)
	end
end
