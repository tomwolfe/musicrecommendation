require_relative '../spec_helper'

describe TracksController do
	describe '#search_tracks' do
		before :each do
			@params_hash = { title: 'Freebird', artist: 'Lynard Skynard', albumn:  }
			@track = FactoryGirl.create(:track)
		end
		it 'calls the model method that searches MusicBrainz' do
			Track.should_receive(:search_musicbrainz).with(@params_hash)
			post :search_tracks, @params_hash
		end
		context 'assign variables for view. renders' do
		before :each do
			post :search_tracks, @params_hash
		end
			it 'makes results in our DB available to the view' do
				pending
				assigns(:tracks).should == [@track]
			end
			it 'makes results in MusicBrainz available to the view' do
				pending
			end
			it 'renders template (maybe redirects?)' do
				pending
			end
		end
	end
end
