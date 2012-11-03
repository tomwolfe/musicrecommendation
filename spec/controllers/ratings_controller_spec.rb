require_relative '../spec_helper'

describe RatingsController do
  before :each do
    Rating.skip_callback(:save, :after, :generate_predictions)
    @rating = FactoryGirl.create(:rating)
    @rating_hash = {id: @rating}
    ApplicationController.any_instance.stub(:current_user).and_return(@rating.user)
  end
  describe '#destroy' do
  	context 'deletes before' do
			before :each do
				delete :destroy, @rating_hash
			end
			it 'destroys the rating' do
				Rating.count.should == 0
			end
			it 'redirects to the ratings_path' do
				response.should redirect_to(ratings_path)
			end
		end
		it 'receives find' do
			Rating.should_receive(:find).with('1').and_return(@rating)
			delete :destroy, @rating_hash
		end
		it 'receives destroy' do
			Rating.any_instance.should_receive(:destroy)
			delete :destroy, @rating_hash
		end
  end
end
