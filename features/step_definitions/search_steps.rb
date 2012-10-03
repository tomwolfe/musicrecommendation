When /^I search for the track (.*)$/ do |search|
  fill_in('Title', :with => search)
  click_button('Search')
end
