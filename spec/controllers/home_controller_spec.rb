require_relative '../spec_helper'

describe HomeController do
	before :each do
		Rating.skip_callback(:save, :after, :generate_predictions)
		Track.any_instance.stub(:must_be_in_musicbrainz).and_return(true)
                @prediction = FactoryGirl.create(:prediction)
		@rating = @prediction.rating
                #prediction_table = NArray[[0.8, 0.8]]
		#CofiCost.any_instance.stub(:predictions).and_return(prediction_table)
		#CofiCost.any_instance.stub(:min_cost).and_return(nil)
	end

	describe '#signedin' do
		before :each do
			ApplicationController.any_instance.stub(:current_user).and_return(@rating.user)
			FactoryGirl.create(:track_create_empty_ratings)
			get :signedin
		end
		it 'makes @search available to the view' do
			assigns(:search).should_not be_valid 
		end
		it 'makes @unrated_predictions available to the view which should only include predictions for unrated tracks (in this case the second track)' do
			assigns(:unrated_predictions).should == [Rating.find(2)]
		end
		it 'makes @ratings available to the view' do
			assigns(:ratings).should == [@rating]
		end
		it 'renders the signedin template' do
			response.should render_template('signedin')
		end
	end

	describe '#signedout' do
		before :each do
			ApplicationController.any_instance.stub(:current_user).and_return(nil)
			get :signedout
		end
		it 'makes @tracks available to the view' do
			assigns(:tracks).should == [@rating.track]
		end
		
		it 'renders the signedout template' do
			response.should render_template('signedout')
		end
	end
end
