Given /^I have rated a track$/ do
  Track.any_instance.stub(:must_be_in_musicbrainz).and_return(true)
  prediction = FactoryGirl.create(:prediction)
  prediction.rating.user_id = User.first.id
  prediction.rating.save
end
