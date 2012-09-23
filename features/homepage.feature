Feature: View the homepage
As a music fan
So that I can have an overview of recent track ratings, recommended tracks, and parties
I want to see my most recent ratings and parties and top recommended unrated tracks (predictions) with the option to view more when I'm signed in.

  Background: on the "MusicRec home" page
    Given I am on the "MusicRec home" page

  Scenario: view the homepage while not signed in
    Given I am not signed in
    Then I should not see signed in items
  
  Scenario: view the homepage while signed in
    Given I am signed in
    Then I should see signed in items
    
  Scenario: the sign in form should be visable upon clicking "Sign In"
    Given I am not signed in
    When I click on "Sign In"
    Then I should see the "Sign In" form
    
  Scenario: the sign in form should not be visable upon clicking "Sign In"
    Given I am not signed in
    Then I should not see the "Sign In" form
    
  Scenario: navigating to the ratings page
    When I click on "More Ratings"
    Then I should be on the "Ratings" page
      And I should see "Search for a track"
  
  @wip
  Scenario: navigating to the parties page
    When I click on "More Parties"
    Then I should be on the "Parties" page
      And I should see ""
  
  Scenario: navigating to the predictions page
    When I click on "More recommended unrated tracks"
    Then I should be on the "Predictions" page
      And I should see "Please rate a track to get personalized recommendations"
      
