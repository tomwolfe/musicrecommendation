require 'spec_helper'

describe HomeController do
  before :each do
    @rating = FactoryGirl.create(:rating)
    ApplicationController.any_instance.stub(:current_user).and_return(@rating.user)
  end

  describe '#signed_in_items' do
    it 'calls ratings on current_user' do
      @rating.user.should_receive(:ratings)
      get :signed_in_items
    end
    it 'makes @ratings available to the view' do
      get :signed_in_items
      assigns(:ratings).should == [@rating]
    end
    it 'makes @predictions available to the view' do
      pending "need to figure out what/how to mock/stub so @predictions won't be nil"
      track2=FactoryGirl.create(:track)
      Prediction.generate_predictions(1)
      mock_model('Prediction', track_id: 1)
      get :signed_in_items
      assigns(:predictions).should == 
    end
    context 'no ratings' do
    end
  end
end
