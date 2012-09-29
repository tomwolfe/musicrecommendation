Feature: Join site

  Background:  on the "New User" page
    Given I am on the "New User" page
      And the following users exist:
      | email     | password      |
      | user@b.com| password      |
      
  Scenario: successfully joining the website with a valid new user
    Given I fill in "Email" with "user@a.com"
      And I fill in "Password" with "password"
    When I press the "Create Account" button
    Then I should be on the "home" page
      And I should see new user items

  Scenario: unsuccessfully joining the website with an invalid new user
    Given I fill in "Email" with "user@.com"
      And I fill in "Password" with "p"
    When I press the "Create Account" button
    Then I should be on the "New User" page
      And I should see "Invalid email"
      
  Scenario: unsuccessfully joining the website with an already existing user
    Given I fill in "Email" with "user@b.com"
      And I fill in "Password" with "password"
    When I press the "Create Account" button
    Then I should be on the "New User" page
      And I should see "User already exists"
