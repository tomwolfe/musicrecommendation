require_relative '../spec_helper'

describe HomeController do
  before :each do
    Rating.skip_callback(:save, :after, :generate_predictions)
    #Rating.stub(:iterate).and_return(1)
    @rating = FactoryGirl.create(:rating)
  end

  describe '#index' do
    context 'signed in' do
      before :each do
        ApplicationController.any_instance.stub(:current_user).and_return(@rating.user)
        FactoryGirl.create(:track)
        @rating.generate_predictions(1)
        Rating.any_instance.stub(:prediction).and_return(2)
        get :index
      end
      it 'makes @predictions available to the view which should only include predictions for unrated tracks (in this case the second track)' do
        assigns(:unrated_predictions).should == [stub_model(Rating, value: 2, prediction: 2, id: 2, track_id: 2)]
      end
      it 'makes @ratings available to the view' do
        assigns(:ratings).should == [@rating]
      end
    end
    
    context 'not signed in' do
    	before :each do
    		ApplicationController.any_instance.stub(:current_user).and_return(nil)
    	end
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
