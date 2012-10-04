require 'spec_helper'

describe RatingsController do
  describe 'create/edit a rating' do
    before :each do
      @fake_rating = mock('Rating', id: '1')
    end
    it 'should create a rating' do
      Rating.should_receive(:create).and_return(@fake_rating)
      post :create, rating: @fake_rating
      response.should redirect_to(rating_path(@fake_rating))
    end
    it 'should show the form to edit a rating' do
      Rating.should_receive(:find).with('1').and_return(@fake_rating)
      get :edit, id: '1'
      response.should render_template('edit')
    end
    it 'should update a rating' do
      pending
    end
    it 'should delete a rating' do
      pending
    end
    it 'should show the edit form and an error for out of range rating' do
      pending
    end
  end
end
