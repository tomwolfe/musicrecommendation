Feature: Search for tracks

	Background:
		Given I am signed in
			And a track exists
			And I am on the "Home signedin" page
			
	Scenario: search for a track that is not in the MusicBrainz database (and thus can't be in the MusicRec database either)
		When I search for a track that is in neither musicrec or musicbrainz
		Then I should be on the "Tracks search" page
			And I should see "No tracks found." in the "#musicrec" area
			And I should see "No tracks found in MusicBrainz" in the "#musicbrainz" area
			But I should not see "Create Track"
			
	Scenario: search for a track that is not in the MusicRec database but is in the MusicBrainz database
		When I search for a track that is only in musicbrainz
		Then I should be on the "Tracks search" page
			And I should see "local h" in the "#musicbrainz" area
			And I should see "No tracks found." in the "#musicrec" area

	Scenario: search for a track that is in the MusicRec database (thus it should be removed from MusicBrainz results)
		When I search for a track that is already in musicrec
		Then I should be on the "Tracks search" page
			And I should see the track in the "#musicrec" area
			But I should not see the track in the "#musicbrainz" area
