When /^I should( not)? see the track$/ do |negate|
	track_name = Track.first.name
	negate ? page.should(have_no_content(track_name)) : page.should(have_content(track_name))
end
