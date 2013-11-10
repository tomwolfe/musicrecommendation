require_relative '../spec_helper'

def update_mbids
	@all_track_mbids = Track.pluck(:mb_id)
end

describe Search do
	before :each do
		@title = "Bound for the Floor"
		@artist = "local h"
		@search = Search.new(track_name: @title, artist_name: @artist)
		@collection =  [{:id=>"ea0ad976-5750-4885-9f33-2c656dfc4a42", :mbid=>"ea0ad976-5750-4885-9f33-2c656dfc4a42", :title=>"Bound for the Floor", :artist=>"Local H", :releases=>["As Good as Dead", "Over the Edge"], :score=>100}, {:id=>"f619ad5b-ae70-4183-87db-21bb811102e1", :mbid=>"f619ad5b-ae70-4183-87db-21bb811102e1", :title=>"Bound for the Floor", :artist=>"Local H", :releases=>["Unplugged & Burnt Out"], :score=>100}, {:id=>"9a0589c9-7dc9-4c5c-9fda-af6cd863095c", :mbid=>"9a0589c9-7dc9-4c5c-9fda-af6cd863095c", :title=>"Bound for the Floor", :artist=>"Local H", :releases=>["WAAF 107. 3 FM: Royal Flush: Live On-Air"], :score=>100}, {:id=>"0158c3e2-25d7-4660-978b-03c2a22ce444", :mbid=>"0158c3e2-25d7-4660-978b-03c2a22ce444", :title=>"Bound for the Floor", :artist=>"Local H", :releases=>["The Point Platinum Version 1.0"], :score=>100}, {:id=>"fd5e41d7-f9d5-4cf6-8ed1-fb0de55d11fa", :mbid=>"fd5e41d7-f9d5-4cf6-8ed1-fb0de55d11fa", :title=>"Bound for the Floor", :artist=>"Local H", :releases=>["Alive '05"], :score=>100}, {:id=>"3b8e47d4-7305-4fc9-b187-48134fcc072a", :mbid=>"3b8e47d4-7305-4fc9-b187-48134fcc072a", :title=>"Bound for the Floor", :artist=>"Local H", :releases=>["Radio 104 WMRQ Back to School"], :score=>100}, {:id=>"7c7fc5d0-b5a9-4d20-90a1-af91b42e8d5c", :mbid=>"7c7fc5d0-b5a9-4d20-90a1-af91b42e8d5c", :title=>"Bound for the Floor", :artist=>"Local H", :releases=>["2004-04-20: Webster Theatre, Hartford, CT, USA"], :score=>100}, {:id=>"950c1b47-d616-4803-8c9a-9b9a99b30b20", :mbid=>"950c1b47-d616-4803-8c9a-9b9a99b30b20", :title=>"Bound for the Floor", :artist=>"Local H", :releases=>["2004-12-31: The Double Door, Chicago, IL, USA"], :score=>100}, {:id=>"6b70baf5-38af-4905-8129-4bc19764280f", :mbid=>"6b70baf5-38af-4905-8129-4bc19764280f", :title=>"Bound for the Floor", :artist=>"Local H", :releases=>["Killer Buzz"], :score=>100}, {:id=>"bb940e26-4265-4909-b128-4906d8b1079e", :mbid=>"bb940e26-4265-4909-b128-4906d8b1079e", :title=>"Bound for the Floor", :artist=>"Local H", :releases=>["Blackrock"], :score=>100}]
		MusicBrainz::Recording.stub(:search).and_return(@collection)
	end
	
	describe '#find_in_musicbrainz' do
		before :each do
			update_mbids
		end
		it 'returns an array of Track objects of tracks found in musicbrainz that are not already in the database' do
			@search.find_in_musicbrainz(@all_track_mbids).first.mb_id.should eq("ea0ad976-5750-4885-9f33-2c656dfc4a42")
			@search.find_in_musicbrainz(@all_track_mbids).size.should eq(10)
		end
		it 'removes tracks found in musicbrainz that are already in the database' do
			track=FactoryGirl.build(:track, name: "Bound for the Floor", artist_name: "Local H", mb_id: "ea0ad976-5750-4885-9f33-2c656dfc4a42")
			track.save(:validate => false)
			update_mbids
			@search.find_in_musicbrainz(@all_track_mbids).size.should eq(9) 
		end
	end
	
	describe '#create_tracks_array' do
		it 'returns an array of Track objects' do
			# only tests the name of the Track object...
			@search.create_tracks_array(@collection).first.name.should eq(@title)
		end
	end

end
