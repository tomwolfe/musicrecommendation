Feature: View your most recently rated tracks

	Background: I am signed in
		Given I am signed in

	Scenario: Twenty tracks have been rated
		Given I have rated 20 tracks
			And I am on the "ratings rated" page
		Then I should see "Next"
