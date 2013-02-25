require_relative '../spec_helper'

describe TracksController do
	before :each do
		@params_hash = { track: { track_name: 'Freebird', artist_name: 'Lynyrd Skynyrd' } }
		@track = FactoryGirl.build(:track)
		@track.save(:validate => false)
		@user = FactoryGirl.create(:user)
		ApplicationController.any_instance.stub(:current_user).and_return(@user)
	end
	describe '#search' do
		before :each do
			@search_hash = { search: @params_hash[:track] }
			@search = Search.new(@params_hash[:track])
			@mb_track = FactoryGirl.build(:track)
			Search.any_instance.stub(:find_in_musicbrainz).and_return([@mb_track])
		end
		it 'calls Search#find_in_musicbrainz' do
			Search.any_instance.should_receive(:find_in_musicbrainz).with([@track.mb_id])
			get :search, @search_hash
		end
		context 'request before expectation' do
			before :each do
				get :search, @search_hash
			end
			it 'makes @tracks available to the view' do
				assigns(:tracks).should == [@track]
			end
			it 'makes @tracks_in_musicbrainz_and_not_db available to the view' do
				assigns(:tracks_in_musicbrainz_and_not_db).should == [@mb_track]
			end
			it 'makes @search available to the view' do
				assigns(:search).track_name.should == @params_hash[:track][:track_name] 
			end
			it 'renders the search template' do
				response.should render_template(:search)
			end
		end
	end
	
	describe '#show' do
		before :each do
			get :show, { id: @track.id }
		end
		it 'renders the show template' do
			response.should render_template(:show)
		end
		it 'makes @track available to the view' do
			assigns(:track).should == @track
		end
	end

	describe '#update' do
		before :each do
			Track.any_instance.stub(:must_be_in_musicbrainz).and_return(true)
			Rating.skip_callback(:save, :after, :generate_predictions)
			@rating = FactoryGirl.create(:rating)
			@update_hash = {"track"=>{"ratings_attributes"=>{"#{@rating.user_id}"=>{"value"=>"5", "id"=>"#{@rating.id}"}}}, "id"=>"#{@rating.track_id}"}
			put :update, @update_hash
		end
		it 'redirects to the signedin home page' do
			response.should redirect_to(home_signedin_path)
		end
		it 'makes @track available to the view' do
			assigns(:track).should == stub_model(Track, id: @rating.track_id, name: @rating.track, artist_name: @rating.track)
		end
		it 'assigns a rating' do
			Rating.find(@rating).value.should == 5
		end
		it 'sets the flash' do
			flash[:notice].should == 'Successfully updated track.'
		end
	end

	describe '#create' do
		before :each do
			Track.any_instance.stub(:must_be_in_musicbrainz).and_return(true)
			@create_hash = { track: { name: 'Freebird', artist_name: 'Lynyrd Skynyrd', mb_id: "9a0589c9-7dc9-4c5c-9fda-af6cd8630940" } }
			post :create, @create_hash
		end
		it 'redirects to the show track page' do
			response.should redirect_to(track_path(2))
		end
		it 'makes @track available to the view' do
			assigns(:track).should == stub_model(Track, id: 2, name: @track, artist_name: @track)
		end
		it 'writes the track to the database' do
			Track.count.should == 2
		end
		it 'sets the flash' do
			flash[:notice].should == 'Track was successfully created.'
		end
	end

	describe '#index' do
		before :each do
			get :index
		end
		it 'renders the index template' do
			response.should render_template(:index)
		end
		it 'makes @tracks available to the view' do
			assigns(:tracks).should == [@track]
		end
		it 'makes @page available to the view' do
			assigns(:page).should == "1"
		end
	end
	
	describe '#itunes' do
		before :each do
			# TODO: change to check @affiliate_should_return once account is setup
			# @affiliate_should_return = ["http://click.linksynergy.com/fs-bin/stat?id=CBIMl*gYY/8&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=https%253A%252F%252Fitunes.apple.com%252Fus%252Falbum%252Fbound-for-the-floor%252Fid255169%253Fi%253D255076%2526uo%253D4%2526partnerId%253D30"]
			@tunes = [{"wrapperType"=>"track", "kind"=>"song", "artistId"=>37771, "collectionId"=>255169, "trackId"=>255076, "artistName"=>"Local H", "collectionName"=>"As Good as Dead", "trackName"=>"Bound for the Floor", "collectionCensoredName"=>"As Good as Dead", "trackCensoredName"=>"Bound for the Floor", "artistViewUrl"=>"https://itunes.apple.com/us/artist/local-h/id37771?uo=4", "collectionViewUrl"=>"https://itunes.apple.com/us/album/bound-for-the-floor/id255169?i=255076&uo=4", "trackViewUrl"=>"https://itunes.apple.com/us/album/bound-for-the-floor/id255169?i=255076&uo=4", "previewUrl"=>"http://a1301.phobos.apple.com/us/r1000/069/Music/9e/8b/ac/mzm.vykyoexn.aac.p.m4a", "artworkUrl30"=>"http://a1.mzstatic.com/us/r1000/000/Features/0a/df/97/dj.kdcejnrw.30x30-50.jpg", "artworkUrl60"=>"http://a5.mzstatic.com/us/r1000/000/Features/0a/df/97/dj.kdcejnrw.60x60-50.jpg", "artworkUrl100"=>"http://a5.mzstatic.com/us/r1000/000/Features/0a/df/97/dj.kdcejnrw.100x100-75.jpg", "collectionPrice"=>7.99, "trackPrice"=>1.29, "releaseDate"=>"1996-04-16T07:00:00Z", "collectionExplicitness"=>"notExplicit", "trackExplicitness"=>"notExplicit", "discCount"=>1, "discNumber"=>1, "trackCount"=>13, "trackNumber"=>3, "trackTimeMillis"=>222960, "country"=>"USA", "currency"=>"USD", "primaryGenreName"=>"Rock"}]
			ITunesSearchAPI.stub(:search).and_return(@tunes)
			get :itunes, { id: @track.id }
		end
		it 'makes @itunes available to the view' do
			# TODO: should == @affiliate_should_return when account is setup
			assigns(:itunes).should == @tunes
		end
		it 'renders the itunes template' do
			response.should render_template(:itunes)
		end
		it 'makes @track available to the view' do
			assigns(:track).should == @track
		end
	end
end
