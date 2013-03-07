When /^I should be on the "(.*)" page$/ do |page|
	page = format_path(page)
	current_path.should == eval("#{page}_path")
end
 
When /^I should( not)? see "(.*)"$/ do |negate, see|
	negate ? page.should(have_no_content(see)) : page.should(have_content(see))
end

When /^I should( not)? see the link "(.*)" pointing to "(.*)"$/ do |negate, see, ref|
	# handle itunes affiliate links/replace with actual Itunes::AFFILIATE_ID
	match = /stat\?id=(.*)&offer/.match ref
	ref.sub!(match[1], Itunes::AFFILIATE_ID) if match
	negate ? page.should(have_no_link(see, href: ref)) : page.should(have_link(see, href: ref))
end

When /^(.*) (.*) exists?$/ do |quantity, thing|
	quantity == "a" ? quantity = 1 : quantity = quantity.to_i
	case
		when thing =~ /user/i then FactoryGirl.create_list(:user, quantity, email: "user@b.com")
		when thing =~ /track/i
			Track.any_instance.stub(:must_be_in_musicbrainz).and_return(true)
			tracks = FactoryGirl.create_list(:track_create_empty_ratings, quantity) #freebird
		when thing =~ /rating/i
			Track.any_instance.stub(:must_be_in_musicbrainz).and_return(true)
			FactoryGirl.create_list(:rating, quantity)
		else FactoryGirl.create_list(thing.to_sym, quantity)
	end
end

When /^I am signed in$/ do
	@current_user = FactoryGirl.create(:user)
	# http://stackoverflow.com/questions/1271788/session-variables-with-cucumber-stories
	rack_test_browser = Capybara.current_session.driver.browser
	cookie_jar = rack_test_browser.current_session.instance_variable_get(:@rack_mock_session).cookie_jar
	cookie_jar[:stub_user_id] = @current_user.id
end

When /^I am on the "(.+)" page$/ do |page|
	page = format_path(page)
	eval("visit #{page}_path")
end

When /^I should( not)? see "(.*)" in the "(.*)" area$/ do |negate, see, area|
	negate ? find(area).should(have_no_content(see)) : find(area).should(have_content(see))
end

When /^I am on the show page for the first "(.*)"$/ do |page|
	page = format_path(page)
	eval("visit #{page}_path(page.classify.constantize.first)")
end

When /^I am on the itunes track page for the first track$/ do
	ITunesSearchAPI.stub(:search).and_return([{"wrapperType"=>"track", "kind"=>"song", "artistId"=>37771, "collectionId"=>255169, "trackId"=>255076, "artistName"=>"Local H", "collectionName"=>"As Good as Dead", "trackName"=>"Bound for the Floor", "collectionCensoredName"=>"As Good as Dead", "trackCensoredName"=>"Bound for the Floor", "artistViewUrl"=>"https://itunes.apple.com/us/artist/local-h/id37771?uo=4", "collectionViewUrl"=>"https://itunes.apple.com/us/album/bound-for-the-floor/id255169?i=255076&uo=4", "trackViewUrl"=>"https://itunes.apple.com/us/album/bound-for-the-floor/id255169?i=255076&uo=4", "previewUrl"=>"http://a1301.phobos.apple.com/us/r1000/069/Music/9e/8b/ac/mzm.vykyoexn.aac.p.m4a", "artworkUrl30"=>"http://a1.mzstatic.com/us/r1000/000/Features/0a/df/97/dj.kdcejnrw.30x30-50.jpg", "artworkUrl60"=>"http://a5.mzstatic.com/us/r1000/000/Features/0a/df/97/dj.kdcejnrw.60x60-50.jpg", "artworkUrl100"=>"http://a5.mzstatic.com/us/r1000/000/Features/0a/df/97/dj.kdcejnrw.100x100-75.jpg", "collectionPrice"=>7.99, "trackPrice"=>1.29, "releaseDate"=>"1996-04-16T07:00:00Z", "collectionExplicitness"=>"notExplicit", "trackExplicitness"=>"notExplicit", "discCount"=>1, "discNumber"=>1, "trackCount"=>13, "trackNumber"=>3, "trackTimeMillis"=>222960, "country"=>"USA", "currency"=>"USD", "primaryGenreName"=>"Rock"}])
	visit itunes_track_path(Track.first)
end

When /^I press the "(.*)" button$/ do |button|
	case
		when button =~ /sign up/i
			UsersController.any_instance.stub(:verify_recaptcha).and_return(true)
			click_button(button)
		when button =~ /update track/i
			Rating.without_callback(:save, :after, :generate_predictions) { click_button(button) }
		when button =~ /create track/i
			Track.any_instance.stub(:must_be_in_musicbrainz).and_return(true)
			click_button(button)
		else click_button(button)
	end
end

When /^I choose (.*)$/ do |radio|
	choose(radio)
end
