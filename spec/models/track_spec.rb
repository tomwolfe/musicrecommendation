require_relative '../spec_helper'

describe Track do
  before :each do
  	track = MusicBrainz::Model::Track.new("http://musicbrainz.org/track/ea0ad976-5750-4885-9f33-2c656dfc4a42", "bound for the floor")
  	track.artist = "local h"
    @scored_collection = MusicBrainz::Model::ScoredCollection.new << track
    Track::QUERY.stub(:get_tracks).and_return(@scored_collection)
    Track::QUERY.stub(:get_track_by_id).and_return(track)
  end
  
	describe '.find_in_musicbrainz' do
	  it '' do
	  	pending
	  end
	end
	
	describe '.create_tracks_array' do
		it 'returns an array of Track objects' do
			# just testing the name of the Track object...
			Track.create_tracks_array(@scored_collection).first.name.should eq("bound for the floor")
		end
	end
	
	describe '.get_track_from_musicbrainz' do
		it '' do
			pending
		end
	end
end
