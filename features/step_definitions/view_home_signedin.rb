Given /^I have rated (.*) tracks?$/ do |quantity|
	quantity == "a" ? quantity = 1 : quantity = quantity.to_i
	Track.any_instance.stub(:must_be_in_musicbrainz).and_return(true)
	FactoryGirl.create_list(:rating, quantity, user_id: User.first.id)
end
