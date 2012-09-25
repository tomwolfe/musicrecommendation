Feature: View the homepage
As a music fan
So that I can start rating tracks to get recommendations
I want to be guided as to where I need to begin (searching for a track to rate) if I'm signed in. If I'm not signed in explain what this site is and how to join.

  Background: on the "MusicRec home" page
    Given I am on the "MusicRec home" page

  Scenario: view the homepage while not signed in
    Given I am not signed in
    Then I should not see signed in items
  
  Scenario: view the homepage while signed in
    Given I am signed in
    Then I should see signed in items