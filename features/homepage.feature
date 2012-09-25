Feature: View the homepage
As a music fan
So that I can start rating tracks to get recommendations
I want to be guided as to where I need to begin (searching for a track to rate) if I'm signed in. If I'm not signed in explain what this site is and how to join.

  Background: on the "MusicRec home" page
    Given I am on the "MusicRec home" page

  Scenario: view the homepage while not signed in
    Given I am not signed in
    Then I should not see "signed in" items
      And I should see "not signed in" items
  
  Scenario: view the homepage while signed in
    Given I am signed in
<<<<<<< HEAD
    Then I should see signed in items
=======
    Then I should see "signed in" items
      And I should not see "not signed in" items
    
  Scenario: navigating to the ratings page
    When I click on "More Ratings"
    Then I should be on the "Ratings" page
      And I should see "Search for a track"
  
  Scenario: navigating to the predictions page
    When I click on "More recommended unrated tracks"
    Then I should be on the "Predictions" page
      And I should see "Please rate a track to get personalized recommendations"
      
  @wip
  Scenario: navigating to the parties page
    When I click on "More Parties"
    Then I should be on the "Parties" page
      And I should see ""
>>>>>>> d33aaa5cf3b47fe98569a27da248da50deb7d531
