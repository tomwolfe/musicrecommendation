require 'spec_helper'

describe RatingsController do
  before :each do
    # very hacky, not sure of a better way to handle this
    # controller.current_user returns @current_user
    # @current_user.ratings returns @fake_rating
    # @fake_rating.find_by_track_id returns @track
    @track = mock('Track', id: '1')
    @fake_rating = mock('Rating', id: '1', user_id: '1', track_id: '1', value: '1', find_by_track_id: @track)
    @current_user = mock('User', id: '1', ratings: @fake_rating)
    controller.stub(:current_user).and_return(@current_user)
  end
  
  describe '#create' do
    it 'creates a rating' do
      Rating.should_receive(:create).and_return(@fake_rating)
      post :create, rating: @fake_rating
    end
    context 'valid rating' do
      before :each do
        post :create, rating: @fake_rating
      end
      it 'makes the results available to the template' do
        assigns(:rating).should == @fake_rating
      end
      it 'redirects to the new rating' do
        response.should redirect_to(rating_path(@fake_rating))
      end
      it 'displays a success message' do
        flash[:notice].should == 'Rating successfully created'
      end
    end
    context 'invalid rating' do
      before :each do
        @invalid_rating = mock('Rating', id: '1', user_id: '1', track_id: '1', value: '-2', find_by_track_id: @track)
        post :create, rating: @invalid_rating
      end
      it 'makes the results available to the template' do
        assigns(:rating).should == @invalid_rating
      end
      it 'shows the template to create a rating' do
        response.should render_template('new')
      end
      it 'displays a failure message' do
        flash[:error].should_not be nil
      end
    end
  end
  
  describe '#edit' do
    before :each do
      @real_rating = FactoryGirl.create(:rating)
    end
    it 'receives the find method' do
      Rating.should_receive(:find).with(@real_rating).and_return(@real_rating)
      get :edit, rating: @real_rating
    end
    it 'makes the results available to the template' do
      get :edit, rating: @real_rating
      assigns(:rating).should == @real_rating
    end
    it 'renders the edit template' do
      get :edit, rating: @real_rating
      response.should render_template('edit')
    end
  end
  
  describe '#update' do
    before :each do
      @real_rating = FactoryGirl.create(:rating)
    end
    it 'finds the rating to update' do
      Rating.should_receive(:find).with(@real_rating).and_return(@real_rating)
      put :update, rating: @real_rating
    end
    it 'makes the results available to the template' do
      put :update, rating: @real_rating
      assigns(:rating).should == @real_rating
    end
    it 'updates the ratings attributes' do
      Rating.should_receive(:update_attributes).with(@real_rating).and_return(@real_rating)
      put :update, rating: @real_rating
    end
  end
  
  describe '#index' do
    it 'calls the -all- method on Rating and returns all ratings' do
      @real_rating = FactoryGirl.create(:rating)
      Rating.should_receive(:all).and_return(@real_rating)
      get :index
    end
    it 'makes the results available to the template' do
      get :index
      assigns(:ratings).should == [@real_rating]
    end
    it 'renders the index template' do
      get :index
      response.should render_template('index')
    end
  end
  
  describe '#destroy' do
    before :each do
      @real_rating = FactoryGirl.create(:rating)
    end
    it 'finds the rating to destroy' do
      Rating.should_receive('find').with(@real_rating).and_return(@real_rating)
      delete :destroy, rating: @real_rating
    end
    it 'calls the destroy method on Rating' do
      Rating.should_receive(:destroy)
      delete :destroy, rating: @real_rating
    end
    it 'redirects to ratings_path' do
      delete :destroy, rating: @real_rating
      response.should redirect_to(ratings_path)
    end      
  end
  
  describe '#new' do
  end
  
  describe '#show' do
  end
end
