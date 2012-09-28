Feature: Authentication
As a music fan
So that I can get personalized recommendations
I want to be able to sign in, sign out, and join with appropriate notifications that those actions failed or succedded.

  Background: on the "home" page
    Given I am on the "home" page
      And the following users exist:
      | email     | password      |
      | user@b.com| password      |

  Scenario: clicking on "join" should display the "New User" page
    When I click on "Join"
    Then I should be on the "New User" page
      And I should see "Password"

  Scenario: successfully joining the website with a valid new user
    Given I fill in the "New User" form with "user@a.com" and "password"
    When I press the "Create Account" button
    Then I should be on the "home" page
      And I should see "new user" items

  Scenario: unsuccessfully joining the website with an invalid new user
    Given I fill in the "New User" form with "user@.com" and "p"
    When I press the "Create Account" button
    Then I should be on the "New User" page
      And I should see "Invalid email"
      
  Scenario: clicking on "sign in" should display the "sign in" page
    When I click on "Sign In"
    Then I should be on the "Sign In" page
      And I should see "Password"

  Scenario: successful sign in
    When I click on "Sign In"
      And I fill in the "Sign In" form with "user@b.com" and "password"
      And I press the "Sign In" button
    Then I should be on the "home" page
      And I should see "signed in" items
      
  Scenario: view homepage before login
    Then I should be on the "home" page
      And I should see "not signed in" items
  
  Scenario: unsuccessful sign in due to invalid credentials
    When I click on "Sign In"
      And I fill in the "Sign In" form with "user@com" and "p"
    Then I should be on the "Sign In" page
      And I should see "No such user exists"
