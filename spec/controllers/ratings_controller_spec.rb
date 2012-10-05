require 'spec_helper'

describe RatingsController do
  before :each do
    @fake_rating = mock('Rating', id: '1')
  end
  
  describe '#create' do
    post :create, rating: @fake_rating
    it 'should receive create and return the rating' do
      Rating.should_receive(:create).and_return(@fake_rating)
      post :create, rating: @fake_rating
    end
    context 'valid rating' do
      response.should redirect_to(rating_path(@fake_rating))
    end
    context 'invalid rating' do
      response.should render_template("new")
    end
  end
  
  describe '#edit' do
  end
  
  describe '#update' do
  end
  
  describe '#index' do
  end
  
  describe '#destroy' do
  end
  
  describe '#new' do
  end
end
