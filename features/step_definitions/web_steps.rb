When /^I should be on the "(.*)" page$/ do |page|
	page = format_path(page)
	current_path.should == eval("#{page}_path")
end
 
When /^I should( not)? see "(.*)"$/ do |negate, see|
	negate ? page.should(have_no_content(see)) : page.should(have_content(see))
end

When /^a (.*) exists$/ do |thing|
	case
		when thing =~ /user/i then FactoryGirl.create(:user, email: "user@b.com")
		when thing =~ /track$/i
			track = FactoryGirl.build(:track, mb_id: "c992037c-1c88-4094-af97-bf466f7d0a87") #freebird
			track.save(validate: false)
			track.create_empty_ratings
		else FactoryGirl.create(thing.to_sym)
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

When /^I press the "(.*)" button$/ do |button|
	case
		when button =~ /sign up/i then UsersController.any_instance.stub(:verify_recaptcha).and_return(true)
		when button =~ /update track/i then Track.any_instance.stub(:update_attributes).and_return(true) # don't want musicbrainz api validation query
	end
	click_button(button)
end

When /^I choose (.*)$/ do |radio|
	choose(radio)
end
