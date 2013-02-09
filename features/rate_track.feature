Feature: Rate a track

	Background: signed in
		Given I am signed in
			And a Track exists
			And I am on the show page for the first "Track"

	Scenario: update rating
		When I choose track_ratings_attributes_0_value_5
			And I press the "Update Track" button
		Then I should be on the "Home signedin" page
			And I should see "Successfully updated"
