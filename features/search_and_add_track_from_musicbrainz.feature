Feature: Search and add tracks from MusicBrainz that are not already in the MusicRec database
As a music fan
So that I can rate tracks not already in the database
I want to add tracks from MusicBrainz to MusicRec.

  Background: signed in and on the "Search" page
    Given I am signed in
      And I am on the "Search" page
      
  Scenario: search for a track that is not in the MusicBrainz database (and thus can't be in the MusicRec database)
    When I search for "Track does not exist in MusicBrainz"
    Then I should see "Track does not exist in MusicRec"
      And I should see "Track does not exist in MusicBrainz"
      And I should see "Add this track to MusicBrainz"
      
  Scenario: search for a track that is not in the MusicRec database but is in the MusicBrainz database
    When I search for "Free Bird"
    Then I should see "Lynard Skynard"
      And I should see "Add to MusicRec from MusicBrainz"
      
  Scenario: search for a track that is not in the MusicRec database but is in the MusicBrainz database and add it from MusicBrainz to MusicRec
    When I search for "Free Bird"
      And I press the "Add" button
    Then I should be on the "track" show page for "Free Bird"
      And I should see "Lynard Skynard"
      And I should see "Rate this track"
      And I should see "0"
