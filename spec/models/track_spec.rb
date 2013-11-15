require_relative '../spec_helper'

def update_mbids
	@all_track_mbids = Track.pluck(:mb_id)
end

describe Track do
	before :each do
		@title = "Bound for the Floor"
		@artist = "local h"
		@valid_mb_id = "ea0ad976-5750-4885-9f33-2c656dfc4a42"
		@mb_recording = MusicBrainz::Recording.new(id: @valid_mb_id, mbid: @valid_mb_id, title: @title, artist: @artist)
	end
	
	describe '#must_be_in_musicbrainz' do
		it 'creates no errors given a valid track' do
			MusicBrainz::Recording.stub(:find).and_return(@mb_recording)
			FactoryGirl.build(:track, name: @title, mb_id: @valid_mb_id, artist_name: @artist).should be_valid
		end
		it 'creates errors given an invalid mb_id' do
			MusicBrainz::Recording.stub(:find).and_return(nil)
			FactoryGirl.build(:track, mb_id: "hi").should_not be_valid
		end
		it 'creates errors given a valid mb_id but non-matching name' do
			MusicBrainz::Recording.stub(:find).and_return(@mb_recording)
			FactoryGirl.build(:track, name: "wrong name", mb_id: @valid_mb_id).should_not be_valid
		end
	end

	describe '#add_errors(title, track_id)' do
		it 'gets called with (no title) and (no id) if the mb_id is not found' do
			MusicBrainz::Recording.stub(:find).and_return(nil)
			track = FactoryGirl.build(:track, mb_id: "hi")
			track.should_receive(:add_errors).with("(no title)", "(no id)")
			track.valid?
		end
		it 'gets called with the correct title/id if the mb_id is found' do
			MusicBrainz::Recording.stub(:find).and_return(@mb_recording)
			track = FactoryGirl.build(:track, name: @title, mb_id: @valid_mb_id, artist_name: @artist)
			track.should_receive(:add_errors).with(@title, @valid_mb_id)
			track.valid?
		end
	end
end
