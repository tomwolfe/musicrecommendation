Feature: View your highest unrated predictions

	Background: I am signed in
		Given I am signed in

	Scenario: Twenty tracks have been rated
		Given 20 tracks exist
			And I am on the "ratings unrated" page
		Then I should see "Next"
