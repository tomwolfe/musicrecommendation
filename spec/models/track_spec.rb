require_relative '../spec_helper'

def update_mbids
	@all_track_mbids = Track.pluck(:mb_id)
end

describe Track do
	before :each do
		@title = "Bound for the Floor"
		@track = MusicBrainz::Model::Track.new("http://musicbrainz.org/track/ea0ad976-5750-4885-9f33-2c656dfc4a42", @title)
		@track.artist = "local h"
	end
	
	describe '#must_be_in_musicbrainz' do
		it 'creates no errors given a valid track' do
			Track::QUERY.stub(:get_track_by_id).and_return(@track)
			FactoryGirl.build(:track, name: @title, mb_id: @track.id.uuid).should be_valid
		end
		it 'raises an InvalidMBIDError given an invalid mb_id' do
			FactoryGirl.build(:track, mb_id: "hi")
			lambda { FactoryGirl.build(:track, mb_id: "hi").valid?.should raise_error(MusicBrainz::Model::InvalidMBIDError) }
		end
		it 'creates errors given a valid mb_id but non-matching name' do
			Track::QUERY.stub(:get_track_by_id).and_return(@track)
			FactoryGirl.build(:track, name: "wrong name", mb_id: @track.id.uuid).should_not be_valid
		end
	end
end
