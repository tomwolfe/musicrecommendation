require_relative '../spec_helper'

describe RatingsController do
  before :each do
    Rating.skip_callback(:save, :after, :generate_predictions)
		Track.any_instance.stub(:must_be_in_musicbrainz).and_return(true)
    @rating = FactoryGirl.create(:rating)
		@rating_hash = {rating: {track_id: @rating, value: @rating}}
    ApplicationController.any_instance.stub(:current_user).and_return(@rating.user)
  end
  
  describe '#create' do
    it 'calls new' do
      Rating.should_receive(:new).with("track_id" => '1', "value" => '1').and_return(@rating)
      post :create, @rating_hash
    end
    it 'calls save' do
      Rating.any_instance.should_receive(:save)
      post :create, @rating_hash
    end
    
    context 'valid rating' do
      before :each do
        Rating.stub(:valid?).and_return(true)
        post :create, @rating_hash
      end
      it 'makes the results available to the template' do
        assigns(:rating).should == mock_model(Rating, id: 2, user_id: 1, track_id: 1, value: 1)
      end
      it 'has another rating in the db' do
      	Rating.count.should == 2
      end
      it 'redirects to the home page' do
        response.should redirect_to(home_signedin_path)
      end
      it 'displays a success message' do
        flash[:notice].should == 'Rating successfully created'
      end
    end
    context 'invalid rating' do
      before :each do
        Rating.any_instance.stub(:valid?).and_return(false)
        @rating_hash[:rating][:value]=-2
        post :create, @rating_hash
      end
      it 'redirects to the home page' do
        response.should redirect_to(home_signedin_path)
      end
      it 'displays an error message' do
        flash[:alert].should == 'Unable to create rating'
      end
    end
  end
  
  describe '#update' do
    it 'calls find_by_id' do
      Rating.should_receive(:find_by_id).with('1').and_return(@rating)
      put :update, {id: 1, rating: { value: 1, track_id: 1 }}
		end
    it 'calls update' do
      Rating.any_instance.should_receive(:update).with("track_id" => '1', "value" => '1').and_return(true)
      put :update, {id: 1, rating: { value: 1, track_id: 1 }}
    end
    context 'after update' do
    	before :each do
    		put :update, {id: 1, rating: { value: 1, track_id: 1 }}
    	end
		  it 'updates the value' do
		  	Rating.first.value.should == 1
		  end
		  it 'redirects to the home page' do
		  	response.should redirect_to(home_signedin_path)
		  end
		end
  end
  
  describe '#destroy' do
  	before :each do
  		@rating_hash = {id: @rating}
  	end
  	context 'deletes before' do
			before :each do
				delete :destroy, @rating_hash
			end
			it 'destroys the rating' do
				Rating.count.should == 0
			end
			it 'redirects to the home_signedin_path' do
				response.should redirect_to(home_signedin_path)
			end
			it 'displays a message that it deleted the rating' do
				flash[:notice].should == "Rating deleted"
			end
		end
		it 'receives find' do
			Rating.should_receive(:find).with('1').and_return(@rating)
			delete :destroy, @rating_hash
		end
		it 'receives destroy' do
			Rating.any_instance.should_receive(:destroy)
			delete :destroy, @rating_hash
		end
  end

	describe '#rated' do
		before :each do
			get :rated
		end
		it 'makes @page available to the view' do
			assigns(:page).should == "1"
		end
		it 'makes @ratings available to the view' do
			assigns(:ratings).should == [@rating]
		end
		it 'renders the rated template' do
			response.should render_template(:rated)
		end
	end

	describe '#unrated' do
		before :each do
			get :unrated
		end
		it 'makes @page available to the view' do
			assigns(:page).should == "1"
		end
		it 'makes @unrated_predictions available to the view' do
			assigns(:unrated_predictions).should be_empty
		end
		it 'renders the rated template' do
			response.should render_template(:unrated)
		end
	end
end
