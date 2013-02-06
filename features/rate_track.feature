Feature: Rate a track

	Background: signed in
		Given I am signed in
			And a Track exists
			And I am on the "Track show" page

	Scenario: update rating
		When I choose 5
			And I press the "Update track" button
		Then I should be on the "Home signedin" page
			And I should see "Successfully updated"
