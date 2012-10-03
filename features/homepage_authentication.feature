Feature: Authentication
As a music fan
So that I can get personalized recommendations
I want to be able to sign in and sign out with appropriate notifications that those actions failed or succedded.

  Background: on the "Home" page with user in db
    Given I am on the "Home" page
      And a user exists

  Scenario: clicking on "Join" should display the "New User" page
    When I click on "Join"
    Then I should be on the "New User" page
      And I should see "Password"
      
  Scenario: clicking on "Sign In" should display the "New Session" (Sign In) page
    When I click on "Sign In"
    Then I should be on the "New Session" page
      And I should see "Password"
      
  Scenario: view homepage before login
    Then I should be on the "View Home" page
      And I should not see signed in items
  
  Scenario: successful sign in
    When I click on "Sign In"
      And I fill in "Email" with "user@b.com"
      And I fill in "Password" with "password"
      And I press the "Sign In" button
    Then I should be on the "View Home" page
      And I should see signed in items
      And I should see "Logged In!"
          
  Scenario: unsuccessful sign in due to invalid credentials
    When I click on "Sign In"
      And I fill in "Email" with "user@com"
      And I fill in "Password" with "p"
    Then I should be on the "Sign In" page
      And I should see "Invalid email or password"
