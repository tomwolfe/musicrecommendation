Feature: Join site

  Background:  on the "New User" page
    Given I am on the "New User" page
      And a user exists
      
  Scenario: successfully joining the website with a valid new user
    Given I fill in "Email" with "user@a.com"
      And I fill in "Password" with "password"
      And I fill in "Confirm Password" with "password"
    When I press the "Sign up" button
    Then I should be on the "Home" page
      And I should see new user items

  Scenario: unsuccessfully joining the website with an invalid new user
    Given I fill in "Email" with "user@.com"
      And I fill in "Password" with "p"
      And I fill in "Confirm Password" with "p"
    When I press the "Sign up" button
    Then I should be on the "Users" page
      And I should see "Invalid email"
      
  Scenario: unsuccessfully joining the website with an already existing user
    Given I fill in "Email" with "user@b.com"
      And I fill in "Password" with "password"
      And I fill in "Confirm Password" with "password"
    When I press the "Sign up" button
    Then I should be on the "Users" page
      And I should see "Email has already been taken"