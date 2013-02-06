Feature: Join site

	Background:  on the "New User" page
		Given I am on the "New User" page
			
	Scenario: successfully joining the website with a valid new user
		Given I fill in the "New User" form with valid data 
		When I press the "Sign up" button
		Then I should be on the "Home Signedin" page
			And I should see "Thanks for joining!"

	Scenario: unsuccessfully joining the website with an invalid new user
		Given I fill in the "New User" form with invalid data 
		When I press the "Sign up" button
		Then I should be on the "Users" page
			And I should see "error prohibited"
