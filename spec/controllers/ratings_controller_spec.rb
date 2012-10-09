require 'spec_helper'

describe RatingsController do
  before :each do
    Rating.skip_callback(:save, :after, :generate_predictions)
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
    context 'invalid rating' do
      before :each do
        Rating.any_instance.stub(:save).and_return(false)
        @rating_hash[:rating][:value]=-2
        post :create, @rating_hash
      end
      it 'shows the template to create a rating' do
        response.should render_template('new')
      end
    end
  end
  describe '#edit' do
    it 'receives the find method' do
      Rating.should_receive(:find).with('1').and_return(@rating)
      get :edit, id: 1
    end
    describe 'template stuff' do
      before :each do
        get :edit, id: 1
      end
      it 'makes the results available to the template' do
        assigns(:rating).should == @rating
      end
      it 'renders the edit template' do
        response.should render_template('edit')
      end
    end
  end
  
  describe '#update' do
    it 'calls find_by_id' do
      @rating.user.ratings.should_receive(:find_by_id).with('1').and_return(@rating)
      put :update, id: 1
    end
    it 'updates attributes' do
      Rating.any_instance.should_receive(:update_attributes).with("track_id" => '1', "value" => '1').and_return(true)
      put :update, {id: 1, rating: { value: 1, track_id: 1 }}
    end
  end
end
