require_relative '../spec_helper'

def update_mbids
	@all_track_mbids = Track.pluck(:mb_id)
end

describe Track do
	before :each do
		@title = "Bound for the Floor"
		@track = MusicBrainz::Model::Track.new("http://musicbrainz.org/track/ea0ad976-5750-4885-9f33-2c656dfc4a42", @title)
		@track.artist = "local h"
		@scored_collection = MusicBrainz::Model::ScoredCollection.new << @track
		Track::QUERY.stub(:get_tracks).and_return(@scored_collection)
		@first_entity_in_collection = @scored_collection.first.entity
	end
	
	describe '.find_in_musicbrainz' do
		before :each do
			update_mbids
		end
		it 'returns an array of Track objects of tracks found in musicbrainz that are not already in the database' do
			Track.find_in_musicbrainz(@all_track_mbids, @first_entity_in_collection.title, @first_entity_in_collection.artist).first.name.should eq(@first_entity_in_collection.title)
		end
		it 'returns an empty array if tracks found in musicbrainz are already in the database' do
			track=FactoryGirl.build(:track, name: @first_entity_in_collection.title, artist_name: @first_entity_in_collection.artist, mb_id: @first_entity_in_collection.id.uuid)
			track.save(:validate => false)
			update_mbids
			Track.find_in_musicbrainz(@all_track_mbids, @first_entity_in_collection.title, @first_entity_in_collection.artist).should be_empty 
		end
	end
	
	describe '.create_tracks_array' do
		it 'returns an array of Track objects' do
			# only tests the name of the Track object...
			Track.create_tracks_array(@scored_collection).first.name.should eq(@title)
		end
	end
	
	describe '#must_be_in_musicbrainz' do
		it 'creates no errors given a valid track' do
			Track::QUERY.stub(:get_track_by_id).and_return(@track)
			FactoryGirl.build(:track, name: @title, mb_id: @first_entity_in_collection.id.uuid).should be_valid
		end
		it 'raises an InvalidMBIDError given an invalid mb_id' do
			FactoryGirl.build(:track, mb_id: "hi")
			lambda { FactoryGirl.build(:track, mb_id: "hi").valid?.should raise_error(MusicBrainz::Model::InvalidMBIDError) }
		end
		it 'creates errors given a valid mb_id but non-matching name' do
			Track::QUERY.stub(:get_track_by_id).and_return(@track)
			FactoryGirl.build(:track, name: "wrong name", mb_id: @first_entity_in_collection.id.uuid).should_not be_valid
		end
	end
end
