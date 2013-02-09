Feature: View the homepage while signed in

	Background: I am signed in
		Given I am signed in

	Scenario: View the homepage after rating a track
		Given I have rated a track
			And I am on the "Home signedin" page
		Then I should not see "You have not yet rated any tracks"
			And I should see "No predictions available that you have not already rated"

	Scenario: View the homepage before rating a track
		Given I am on the "Home signedin" page
		Then I should see "You have not yet rated any tracks"
			And I should see "No predictions available that you have not already rated"
