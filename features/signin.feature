Feature: Authentication
			
	Background: on the "New Session" page with user in db
		Given I am on the "New Session" page
			And a user exists
			
	Scenario: successful sign in
		When I fill in the "Sign In" form with valid data
			And I press the "Sign In" button
		Then I should be on the "Signedin" page
			And I should see "Successfully signed in"
					
	Scenario: unsuccessful sign in due to invalid credentials
		When I fill in the "Sign In" form with invalid data
			And I press the "Sign In" button
		Then I should be on the "New Session" page
			And I should see "errors"
