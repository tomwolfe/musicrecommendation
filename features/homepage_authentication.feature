Feature: Authentication
As a music fan
So that I can get personalized recommendations
I want to be able to sign in and sign out with appropriate notifications that those actions failed or succedded.

  Background: on the "home" page
    Given I am on the "home" page
      And the following users exist:
      | email     | password      |
      | user@b.com| password      |

  Scenario: clicking on "join" should display the "New User" page
    When I click on "Join"
    Then I should be on the "New User" page
      And I should see "Password"
      
  Scenario: clicking on "sign in" should display the "sign in" page
    When I click on "Sign In"
    Then I should be on the "Sign In" page
      And I should see "Password"
      
  Scenario: view homepage before login
    Then I should be on the "home" page
      And I should not see signed in items
  
  Scenario: successful sign in
    When I click on "Sign In"
      And I fill in "Email" with "user@b.com"
      And I fill in "Password" with "password"
      And I press the "Sign In" button
    Then I should be on the "home" page
      And I should see signed in items
      And I should see "Logged In!"
          
  Scenario: unsuccessful sign in due to invalid credentials
    When I click on "Sign In"
      And I fill in "Email" with "user@com"
      And I fill in "Password" with "p"
    Then I should be on the "Sign In" page
      And I should see "Invalid email or password"
