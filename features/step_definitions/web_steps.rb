When /I am on the "(.*)" page/ do |page|
  page=format_path(page)
  eval("visit #{page}_path")
end

When /I click on "(.*)"/ do |link|
  click_link(link)
end

When /^I should be on the "(.*)" page$/ do |page|
  page=format_path(page)
  current_path.should == eval("#{page}_path")
end

When /^I should be on the "(.*)" show page for field "(.*)" with value "(.*)"$/ do |model, field, value|
  id = eval("#{model}.find_by_#{field}(value)")
  current_path.should == eval("#{page}_path(id)")
end


When /^I should( not)? see "(.*)"$/ do |negate, see|
  negate ? page.should(have_no_content(see)) : page.should(have_content(see))
end

When /I fill in "(.*)" with "(.*)"/ do |field, value|
  fill_in(field, :with => value)
end

When /I press the "(.*)" button/ do |button|
  click_button(button)
end

When /^I should( not)? see the link "(.*)" in the "(.*)" section$/ do |negate, link, section|
  negate ? find(section).should_not(have_link(link)) : find(section).should(have_link(link))
end

When /^I should( not)? see the link "(.*)"$/ do |negate, link|
  negate ? page.should_not(have_link(link)) : page.should(have_link(link))
end

'''When /the following (.*) exist/ do |things, things_table|
  thing=things[0..-2].capitalize # remove plurality
  things_table.hashes.each do |thing_table|
    eval("#{thing}.create!(thing_table)")
    # each returned element will be a hash whose key is the table header.
  end
end'''
