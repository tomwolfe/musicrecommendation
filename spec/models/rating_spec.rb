require_relative '../spec_helper'

# oddly enough, gsl does not get installed in /var/lib/gems/... with 'bundle install'
# had to manually clone git repo and build/install it

describe Rating do
  describe '#generate_predictions' do
    before :each do
    	Rating.skip_callback(:save, :after, :generate_predictions)
    	@rating = FactoryGirl.create(:rating)
      @track2 = FactoryGirl.create(:track)
    end
    it 'updates the average_rating for the track it belongs to' do
      @rating.track.average_rating.should eq(1.0)
    end
    context 'predictions' do
      before :each do
        CofiCost.any_instance.stub(:predictions).and_return(NArray[[0.8],[0.7]])
        CofiCost.any_instance.stub(:min_cost).and_return(nil)
        @rating.generate_predictions(1)
      end
		  it 'generates predictions' do
		    Rating.find(2).prediction.should be == 0.7
		  end
		  it 'builds the rating table' do
		    pending
		  end
		end
  end
end
