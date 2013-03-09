Feature: Rate a track

	Background: signed in
		Given I am signed in
			And a Track exists
			And I am on the show page for the first "Track"

	Scenario: update rating
		When I choose rating_value_5
			And I press the "Update Rating" button
		Then I should be on the "Home signedin" page
			And I should see "Rating successfully updated"
