Feature: View the homepage while signed in

	Background: I am signed in, I have rated a track, and I'm on the homepage
		Given I am signed in
			And I am on the "Home signedin" page

	Scenario: View the homepage after rating a track
		Given I have rated a track
		Then I should not see "You have not yet rated any tracks"
			And I should not see "No predictions available that you have not already rated"

	Scenario: View the homepage before rating a track
		Then I should see the track name
