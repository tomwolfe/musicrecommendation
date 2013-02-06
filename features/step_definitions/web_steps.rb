When /^I should be on the "(.*)" page$/ do |page|
	page = format_path(page)
	current_path.should == eval("#{page}_path")
end
 
When /^I should( not)? see "(.*)"$/ do |negate, see|
	negate ? page.should(have_no_content(see)) : page.should(have_content(see))
end
