require 'spec_helper'

describe HomeController do
  before :each do
    Rating.skip_callback(:save, :after, :generate_predictions)
    @rating = FactoryGirl.create(:rating)
    ApplicationController.any_instance.stub(:current_user).and_return(nil)
  end

  describe '#index' do
    context 'signed in' do
      before :each do
        ApplicationController.any_instance.stub(:current_user).and_return(@rating.user)
        FactoryGirl.create(:track)
        Prediction.generate_predictions(1)
        Prediction.any_instance.stub(:value).and_return(2)
        get :index
      end
      it 'makes @predictions available to the view which should only include predictions for unrated tracks (in this case the second track)' do
        assigns(:predictions).should == [stub_model(Prediction, value: 2, id: 2, track_id: 2)]
      end
      it 'makes @ratings available to the view' do
        assigns(:ratings).should == [@rating]
      end
    end
    
    context 'not signed in' do
      it 'makes @tracks available to the view' do
        get :index
        assigns(:tracks).should == [@rating.track]
      end
    end
    
    it 'renders the index template' do
      get :index
      response.should render_template('index')
    end
  end
end
