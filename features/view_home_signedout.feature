Feature: View the homepage while not signed in

	Background: on the "Signedin" page
		Given I am on the "Home signedin" page

	Scenario: A Track has been rated
		Given a rating exists
		Then I should not see "No tracks"
			But I should see the track name

	Scenario: No tracks have been rated
		Then I should see "No tracks"
