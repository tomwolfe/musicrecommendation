Feature: Add a track from search

	Background: signed in and on the search page with a track to create
		Given I am signed in
			And I search for a track that exists in musicbrainz
			
	Scenario: create track
		When I click "Create Track"
		Then I should be on the "Show Track" page
