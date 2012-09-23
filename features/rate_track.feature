Feature: Rate tracks
As a music fan
So that I can receive collaborative recommendations for new tracks to listen to
I want to rate tracks.

  Background: signed in on the "Ratings" page
    Given I am on the "Ratings" page
      And I am signed in

  Scenario: search for a track that does exist in the database
    Given that "Free Bird" by "Lynard Skynard" does exist in the database
    When I search for "Free Bird"
    Then I should be on the "Search results" page
      And I should see "Lynard Skynard"
      And I should see "Correct track not listed? Add it from the MusicBrainz database"
  
  Scenario: search for a track that does not exist in the database and is in the MusicBrainz database
    Given that "Free Bird" by "Lynard Skynard" does not exist in the database
    When I search for "Free Bird"
    Then I should be on the "Search results" page
      And I should see "Track not found in our database"
      And I should see "Add this track to our database from the MusicBrainz database to rate it"

  @wip
  Scenario: search for a track that is not in the database and is not in the MusicBrainz database
