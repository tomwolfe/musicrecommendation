When /^I am on the "(.+)" page$/ do |page|
	page = format_path(page)
	eval("visit #{page}_path")
end

When /^I fill in the "New User" form with valid data$/ do
	fill_in "user_email", with: "a+no@a.com"
	fill_in "user_password", with: "password1"
	fill_in "user_password_confirmation", with: "password1"
end

When /^I press the "Sign up" button$/ do
	UsersController.any_instance.stub(:verify_recaptcha).and_return(true)
	click_button("Sign up")
end

When /^I fill in the "New User" form with invalid data$/ do
	fill_in "user_email", with: "a+no@.com"
	fill_in "user_password", with: "password1"
	fill_in "user_password_confirmation", with: "password1"
end
