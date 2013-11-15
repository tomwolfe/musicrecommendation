When /^I search for a track that is in neither musicrec or musicbrainz$/ do
	MusicBrainz::Recording.stub(:search).and_return([])
	fill_in "search_track_name", with: "dne"
	fill_in "search_artist_name", with: "dne"
	click_button("Search")
end

When /^I search for a track that is only in musicbrainz$/ do
	@title = "Bound for the Floor"
	@artist = "local h"
	@collection = [{:id=>"c992037c-1c88-4094-af97-bg466f7d0101", :mbid=>"c992037c-1c88-4094-af97-bg466f7d0101", :title=>@title, :artist=>@artist, :releases=>["As Good as Dead", "Over the Edge"], :score=>100}]
	MusicBrainz::Recording.stub(:search).and_return(@collection)
	fill_in "search_track_name", with: @title
	fill_in "search_artist_name", with: @artist
	click_button("Search")
end

When /^I search for a track that is already in musicrec$/ do
	track = Track.first
	@title = track.name
	@artist = track.artist_name
	@collection = [{:id=>"c992037c-1c88-4094-af97-bf466f7d0102", :mbid=>"c992037c-1c88-4094-af97-bf466f7d0102", :title=>@title, :artist=>@artist, :releases=>["As Good as Dead", "Over the Edge"], :score=>100}]
	MusicBrainz::Recording.stub(:search).and_return(@collection)
	fill_in "search_track_name", with: @title
	fill_in "search_artist_name", with: @artist
	click_button("Search")
end

When /^I should( not)? see the track in the "(.*)" area$/ do |negate, area|
	artist_name = Track.first.artist_name
	negate ? find(area).should(have_no_content(artist_name)) : find(area).should(have_content(artist_name))
end
