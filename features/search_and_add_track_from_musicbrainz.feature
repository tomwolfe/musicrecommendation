Feature: Search and add tracks from MusicBrainz that are not already in the MusicRec database
As a music fan
So that I can rate tracks not already in the database
I want to add tracks from MusicBrainz to MusicRec.

  Background: signed in and on the "Search Tracks" page
    Given I sign in
      And a rating exists
      And I am on the "Search Tracks" page
      
  Scenario: search for a track that is not in the MusicBrainz database (and thus can't be in the MusicRec database)
    When I search for the track "Track does not exist in MusicBrainz"
    Then I should see "Track does not exist in MusicRec"
      And I should see "Track does not exist in MusicBrainz"
      And I should see "Add this track to MusicBrainz"
      
  Scenario: search for a track that is not in the MusicRec database but is in the MusicBrainz database
    When I search for the track "Buffelo Trace"
    Then I should see "Local H"
      And I should see "Add to MusicRec from MusicBrainz"
      
  Scenario: search for a track that is not in the MusicRec database but is in the MusicBrainz database and add it from MusicBrainz to MusicRec
    When I search for the track "Buffelo Trace"
      And I press the "Add to MusicRec from MusicBrainz" button
    Then I should be on the "track" show page
      And I should see "Local H"
      And I should see "Rate this track"
