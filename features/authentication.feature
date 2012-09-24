Feature: Authentication
As a music fan
So that I can get personalized recommendations
I want to be able to sign in, sign out, and join with appropriate notifications that those actions failed or succedded.

  Background: on the "MusicRec home" page
    Given I am on the "MusicRec home" page

  Scenario: the sign in form should be visable upon clicking "Sign In"
    Given I am not signed in
    When I click on "Sign In"
    Then I should see the "Sign In" form
      And I should be on the "MusicRec home" page
    
  Scenario: the sign in form should not be visable until "Sign In" is clicked
    Given I am not signed in
    Then I should not see the "Sign In" form

  Scenario: clicking on join should display the "New User" page
    Given I am not signed in
    When I click on "Join"
    Then I should be on the "New User" page
      And I should see "Password"

  Scenario: successfully joining the website with a valid new user
    Given I fill in the "New User" form with valid inputs
    When I click "Create Account"
    Then I should be on the "MusicRec home" page
      And I should see "Welcome back"

  Scenario: unsuccessfully joining the website with an invalid new user
    Given I fill in the "New User" form with invalid inputs
    When I click "Create Account"
    Then I should be on the "New User" page
      And I should see "Error"

  
