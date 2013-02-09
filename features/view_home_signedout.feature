Feature: View the homepage while not signed in

	Scenario: A Track has been rated
		Given a rating exists
			And I am on the "Home signedout" page
		Then I should not see "No tracks"
			But I should see the track

	Scenario: No tracks have been rated
		Given I am on the "Home signedout" page
		Then I should see "No tracks"
