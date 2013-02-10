Feature: Add a track from search

	Background: signed in and on the search page with a track to create
		Given I am signed in
			And I am on the "Home signedin" page
			And I search for a track that is only in musicbrainz
			
	Scenario: create track
		When I press the "Create Track" button
		Then I am on the show page for the first "Track"
			And I should see "local h"
