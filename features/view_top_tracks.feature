Feature: View the top rated tracks

	Scenario: Twenty tracks have been rated
		Given 20 ratings exist
			And I am on the "tracks" page
		Then I should not see "No tracks"
			And I should see "Next"
