Feature: View the homepage with a rated track
As a music fan who is signed in and has rated at least one track
So that I can have an overview of my recent track ratings, and recommended tracks
I want to see my most recent ratings, top recommended unrated tracks (predictions) and a link to search for more tracks to rate.

  Background: I am signed in, I have rated a track, and I'm on the homepage
    Given a rating exists
      And I am on the "Home" page
      And I am signed in
      
  Scenario: I should see "More Ratings/More Predictions/Your Rating/Rating Guess"
    Then I should see items pertaining to having rated a track

  Scenario: navigating to the ratings page
    When I click on "More Ratings"
    Then I should be on the "Ratings" page
      And I should see "Your Ratings"
      And I should see "Freebird"

  Scenario: navigating to the predictions page
    When I click on "More Predictions"
    Then I should be on the "Predictions" page
      And I should see "Predictions: Tracks that we think you'll like that you've yet to rate"
