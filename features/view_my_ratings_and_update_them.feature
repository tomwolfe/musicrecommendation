Feature: View tracks that I've rated and be able to change those ratings
As a music fan
So that I can receive collaborative recommendations for new tracks to listen to
I want to view tracks I've rated and change those ratings

  Background: signed in on the "Search" page
    Given a rating exists
      And I sign in
      And I am on the "Ratings" page

  Scenario: successfully update a tracks rating (default 0-unrated)
    When  I press the "rating_1_value_1" button
    Then I should be on the "Ratings" page
      And I should see "Rating successfully updated"
