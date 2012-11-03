require_relative '../spec_helper'

describe TracksController do
	describe '#search_tracks' do
		before :each do
			@params_hash = { track_name: 'Freebird', artist_name: 'Lynyrd Skynyrd' }
			@track = FactoryGirl.create(:track)
			@user = FactoryGirl.create(:user)
			ApplicationController.any_instance.stub(:current_user).and_return(@user)
			#MusicBrainz::Webservice::Query.stub(:get_tracks).and_return()
		end
		it 'calls the musicbrainz get_tracks method' do
			get :search, @params_hash
			assigns(:tracks).should == [nil]
		end
	end
end
