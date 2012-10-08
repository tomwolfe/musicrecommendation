require 'spec_helper'

describe RatingsController do
  before :each do
    Rating.skip_callback(:save, :after, :generate_predictions)
    @track = FactoryGirl.create(:track)
    @user = FactoryGirl.create(:user)
    @rating = FactoryGirl.create(:rating)
    @rating_hash = {rating: {track_id: @rating, value: @rating}}
    ApplicationController.any_instance.stub(:current_user).and_return(@user)
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
        Rating.stub(:save).and_return(true)
        post :create, @rating_hash
      end
      it 'makes the results available to the template' do
        assigns(:rating).should == mock_model(Rating, id: 2, user_id: 1, track_id: 1, value: 1)
      end
      it 'redirects to the new rating' do
        response.should redirect_to(rating_path(2))
      end
      it 'displays a success message' do
        flash[:notice].should == 'Rating successfully created'
      end
    end
  end
end
