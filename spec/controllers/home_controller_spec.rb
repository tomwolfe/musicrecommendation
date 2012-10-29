require_relative '../spec_helper'

describe HomeController do
  before :each do
    Rating.skip_callback(:save, :after, :generate_predictions)
    @rating = FactoryGirl.create(:rating)
    prediction_table = NArray[[0.8],[0.7]]
  	CofiCost.any_instance.stub(:predictions).and_return(prediction_table)
		CofiCost.any_instance.stub(:min_cost).and_return(nil)
  end

  describe '#index' do
    context 'signed in' do
      before :each do
        ApplicationController.any_instance.stub(:current_user).and_return(@rating.user)
        FactoryGirl.create(:track)
        @rating.generate_predictions(1)
        get :index
      end
      it 'makes @predictions available to the view which should only include predictions for unrated tracks (in this case the second track)' do
        assigns(:unrated_predictions).should == [Rating.find(2)]
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
