require_relative '../spec_helper'

def update_mbids
	@all_track_mbids = Track.pluck(:mb_id)
end

describe Search do
	before :each do
		@title = "Bound for the Floor"
		@track = MusicBrainz::Model::Track.new("http://musicbrainz.org/track/ea0ad976-5750-4885-9f33-2c656dfc4a42", @title)
		@track.artist = "local h"
		@scored_collection = MusicBrainz::Model::ScoredCollection.new << @track
		Track::QUERY.stub(:get_tracks).and_return(@scored_collection)
		@first_entity_in_collection = @scored_collection.first.entity
		@search = Search.new(track_name: @title, artist_name: @track.artist)
	end
	
	describe '#find_in_musicbrainz' do
		before :each do
			update_mbids
		end
		it 'returns an array of Track objects of tracks found in musicbrainz that are not already in the database' do
			@search.find_in_musicbrainz(@all_track_mbids).first.name.should eq(@first_entity_in_collection.title)
		end
		it 'returns an empty array if tracks found in musicbrainz are already in the database' do
			track=FactoryGirl.build(:track, name: @first_entity_in_collection.title, artist_name: @first_entity_in_collection.artist, mb_id: @first_entity_in_collection.id.uuid)
			track.save(:validate => false)
			update_mbids
			@search.find_in_musicbrainz(@all_track_mbids).should be_empty 
		end
	end
	
	describe '#create_tracks_array' do
		it 'returns an array of Track objects' do
			# only tests the name of the Track object...
			@search.create_tracks_array(@scored_collection).first.name.should eq(@title)
		end
	end

end
