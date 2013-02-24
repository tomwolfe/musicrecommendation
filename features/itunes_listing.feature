Feature: View links to buy a track on iTunes

	Background: I am signed in
		Given I am signed in
			And I am on the itunes track page for the first track

	Scenario: I should see a link to purchase the track on itunes
		Then I should see the link "Show on iTunes" pointing to "https://itunes.apple.com/us/album/bound-for-the-floor/id255169?i=255076&uo=4"
