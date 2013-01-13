require_relative '../spec_helper'

describe TracksController do
	before :each do
		@params_hash = { track_name: 'Freebird', artist_name: 'Lynyrd Skynyrd' }
		@track = FactoryGirl.build(:track)
		@track.save(:validate => false)
		#User.skip_callback(:create, :after, :create_empty_ratings)
		@user = FactoryGirl.create(:user)
		ApplicationController.any_instance.stub(:current_user).and_return(@user)
	end
	describe '#search' do
		before :each do
			@mb_track = FactoryGirl.build(:track)
			Track.stub(:find_in_musicbrainz).and_return([@mb_track])
		end
		it 'calls Track.find_in_musicbrainz' do
			Track.should_receive(:find_in_musicbrainz).with([nil], 'Freebird', 'Lynyrd Skynyrd')
			get :search, @params_hash
		end
		context 'request before expectation' do
			before :each do
				get :search, @params_hash
			end
			it 'makes @tracks available to the view' do
				assigns(:tracks).should == [@track]
			end
			it 'makes @tracks_in_musicbrainz_and_not_db available to the view' do
				assigns(:tracks_in_musicbrainz_and_not_db).should == [@mb_track]
			end
			it 'renders the search template' do
				response.should render_template(:search)
			end
		end
	end
	
	describe '#show' do
		before :each do
			@show_hash = { id: 1 }
			get :show, @show_hash
		end
		it 'renders the show template' do
			response.should render_template(:show)
		end
		it 'makes @track available to the view' do
			assigns(:track).should == @track
		end
	end
	
	describe '#create' do
		before :each do
			Track.any_instance.stub(:must_be_in_musicbrainz).and_return(true)
			@create_hash = { track: { name: 'Freebird', artist_name: 'Lynyrd Skynyrd' } }
			post :create, @create_hash
		end
		it 'should redirect to the show track page' do
			response.should redirect_to(track_path(2))
		end
		it 'should make @track available to the view' do
			assigns(:track).should == stub_model(Track, id: 2, name: @track, artist_name: @track)
		end
		it 'writes the track to the database' do
			Track.count.should == 2
		end
		it 'sets the flash' do
			flash[:notice].should == 'Track was successfully created.'
		end
	end
end
