Given /^I have rated a track$/ do
	Track.any_instance.stub(:must_be_in_musicbrainz).and_return(true)
	FactoryGirl.create(:track)
	FactoryGirl.create(:rating, user_id: User.first.id, track_id: Track.first.id)
end
