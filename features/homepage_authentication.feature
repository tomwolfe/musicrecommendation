Feature: Authentication
As a music fan
So that I can get personalized recommendations
I want to be able to sign in, sign out, and join with appropriate notifications that those actions failed or succedded.

  Background: on the "MusicRec home" page
    Given I am on the "MusicRec home" page

  Scenario: clicking on join should display the "New User" page
    When I click on "New User"
    Then I should be on the "New User" page
      And I should see "Password"

  Scenario: successfully joining the website with a valid new user
    Given I fill in the "New User" form with valid inputs
    When I click "Create Account"
    Then I should be on the "MusicRec home" page
      And I should see new user items

  Scenario: unsuccessfully joining the website with an invalid new user
    Given I fill in the "New User" form with invalid inputs
    When I click "Create Account"
    Then I should be on the "New User" page
      And I should see "Error"
      
  Scenario: clicking on "sign in" should display the "sign in" page
    Given I have joined the website
    When I click on "Sign In"
    Then I should be on the "Sign In" page
      And I should see "Password"

  Scenario: sucessful sign in
    Given I have joined the website
    When I click on "Sign In"
      And I fill in the "Sign In" form with valid credentials
    Then I should see signed in items
  
    Scenario: unsucessful sign in due to invalid credentials
    When I click on "Sign In"
      And I fill in the "Sign In" form with invalid credentials
    Then I should be on the "Sign In" page
      And I should see "No such user exists"
