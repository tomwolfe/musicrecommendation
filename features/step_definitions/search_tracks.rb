When /^I search for a track that is in neither musicrec or musicbrainz$/ do
	MusicBrainz::Webservice::Query.any_instance.stub(:get_tracks).and_return(nil)
	fill_in "search_track_name", with: "dne"
	fill_in "search_artist_name", with: "dne"
	click_button("Search")
end

When /^I search for a track that is only in musicbrainz$/ do
	@title = "Bound for the Floor"
	@track = MusicBrainz::Model::Track.new("http://musicbrainz.org/track/ea0ad976-5750-4885-9f33-2c656dfc4a42", @title)
	@track.artist = "local h"
	@scored_collection = MusicBrainz::Model::ScoredCollection.new << @track
	MusicBrainz::Webservice::Query.any_instance.stub(:get_tracks).and_return(@scored_collection)
	fill_in "search_track_name", with: @title
	fill_in "search_artist_name", with: @track.artist
	click_button("Search")
end

When /^I search for a track that is already in musicrec$/ do
	track = Track.first
	@title = track.name
	@track = MusicBrainz::Model::Track.new("http://musicbrainz.org/track/c992037c-1c88-4094-af97-bf466f7d0a87", @title)
	@track.artist = track.artist_name
	@scored_collection = MusicBrainz::Model::ScoredCollection.new << @track
	MusicBrainz::Webservice::Query.any_instance.stub(:get_tracks).and_return(@scored_collection)
	fill_in "search_track_name", with: @title
	fill_in "search_artist_name", with: @track.artist
	click_button("Search")
end

When /^I should( not)? see the track in the "(.*)" area$/ do |negate, area|
	track_name = Track.first.name
	negate ? find(area).should(have_no_content(track_name)) : find(area).should(have_content(track_name))
end