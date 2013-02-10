When /^I fill in the "Sign In" form with valid data$/ do
	user = User.first
	fill_in "email", with: user.email
	fill_in "password", with: "password"
end

When /^I fill in the "Sign In" form with invalid data$/ do
	fill_in "email", with: "no@no"
	fill_in "password", with: "invalid"
end
