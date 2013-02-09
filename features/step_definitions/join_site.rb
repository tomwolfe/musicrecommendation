When /^I fill in the "New User" form with valid data$/ do
	fill_in "user_email", with: "a+no@a.com"
	fill_in "user_password", with: "password1"
	fill_in "user_password_confirmation", with: "password1"
end

When /^I fill in the "New User" form with invalid data$/ do
	fill_in "user_email", with: "a+no@.com"
	fill_in "user_password", with: "password1"
	fill_in "user_password_confirmation", with: "password1"
end
