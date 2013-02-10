Feature: Signout
			
	Background: on the "Home signedin" page
		Given I am signed in
			And I am on the "Home Signedin" page

			
	Scenario: successful signout
		When I press the "Sign Out" button
		Then I should be on the "Home Signedout" page
			And I should see "You have been logged out."
