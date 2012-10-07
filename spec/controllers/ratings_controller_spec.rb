require 'spec_helper'

describe RatingsController do
  before :each do
    Rating.skip_callback(:save, :after, :generate_predictions)
    ApplicationController.any_instance.stub(:current_user).and_return(mock_model('User', id: '1'))
    @stub_rating = stub_model(Rating, id: '1', user_id: '1', track_id: '1')
    # very hacky, I'm not sure of a better way to handle this
    @track = mock('Track', id: '1')
    @fake_rating = mock('Rating', id: '1', user_id: '1', track_id: '1', value: '1')
    @current_user = mock('User', id: '1')
    @rating_hash = {rating: {track_id: @stub_rating, value: @stub_rating}}
    ApplicationController.any_instance.stub(:current_user).and_return(@current_user)
  end
  
  describe '#create' do
    it 'calls new' do
      Rating.should_receive(:new).with("track_id" => '1', "value" => '1').and_return(@stub_rating)
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
        assigns(:rating).should == @stub_rating
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
        Rating.stub(:save).and_return(false)
        post :create, rating: @fake_rating
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
      Rating.stub(:find).and_return(@fake_rating)
    end
    it 'receives the find method' do
      Rating.should_receive(:find).with(@fake_rating)
      get :edit, rating: @fake_rating
    end
    it 'makes the results available to the template' do
      get :edit, rating: @fake_rating
      assigns(:rating).should == @fake_rating
    end
    it 'renders the edit template' do
      get :edit, rating: @fake_rating
      response.should render_template('edit')
    end
  end
  
  describe '#update' do
    before :each do
      Rating.stub(:update_attributes).and_return(true)
      Rating.stub(:find_by_track_id).and_return(@track)
      User.stub(:ratings).and_return([@fake_rating])
    end
    it 'calls ratings on user' do
      User.should_receive(:ratings)
      put :update, rating: @fake_rating
    end
    it 'calls find_by_track_id on rating' do
      # I'm not sure if this'll work (track_id in params[:rating] hash)
      #   => params[:rating][:track_id] (maybe?)
      #   hidden field for track_id in view
      Rating.should_receive(:find_by_track_id).with(@fake_rating)
      put :update, rating: @fake_rating
    end
    it 'updates the ratings attributes' do
      Rating.should_receive(:update_attributes).with(@fake_rating)
      put :update, rating: @fake_rating
    end
    describe 'template' do
      before :each do
        put :update, rating: @fake_rating
      end
      it 'makes the results available to the template' do
        assigns(:rating).should == @fake_rating
      end
      it 'displays a success message' do
        flash[:notice].should == 'Your rating has been updated'
      end
    end
  end
  
  describe '#index' do
    before :each do
      Rating.stub(:all).and_return([@fake_rating])
    end
    it 'calls the -all- method on Rating' do
      Rating.should_receive(:all)
      get :index
    end
    describe 'template' do
      before :each do
        get :index
      end
      it 'makes the results available to the template' do
        assigns(:ratings).should == [@fake_rating]
      end
      it 'renders the index template' do
        response.should render_template('index')
      end
    end
  end
  
  describe '#destroy' do
    before :each do
      Rating.stub(:find).and_return(@fake_rating)
      Rating.stub(:destroy).and_return(true)
    end
    it 'finds the rating to destroy' do
      Rating.should_receive(:find).with(@fake_rating)
      delete :destroy, rating: @fake_rating
    end
    it 'calls the destroy method on Rating' do
      Rating.should_receive(:destroy)
      delete :destroy, rating: @fake_rating
    end
    it 'redirects to ratings_path' do
      delete :destroy, rating: @fake_rating
      response.should redirect_to(ratings_path)
    end      
  end
  
  describe '#new' do
    before :each do
      @empty_rating = mock('Rating')
      Rating.stub(:new).and_return(@empty_rating)
    end
    it 'calls the new method on Rating' do
      Rating.should_receive(:new)
      get :new
    end
    it 'makes the new rating object available to the template' do
      get :new
      assigns(:rating).should == @empty_rating
    end
  end
  
  describe '#show' do
    before :each do
      Rating.stub(:find).and_return(@fake_rating)
    end
    it 'receives the find method with the Rating' do
      Rating.should_receive(:find).with(@fake_rating)
      get :show, @fake_rating
    end
    it 'makes the rating object available to the template' do
      get :show, @fake_rating
      assigns(:rating).should == @fake_rating
    end
  end
end
