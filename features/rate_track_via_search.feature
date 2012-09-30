Feature: Rate tracks via search
As a music fan
So that I can receive collaborative recommendations for new tracks to listen to
I want to rate tracks.

  Background: signed in on the "Search" page
    Given I am signed in
      And the following tracks exist:
      | title           | artist        |
      | Free Bird       | Led Zeppelin  |
      And I am on the "Ratings" page
      And I click on "Free Bird"

  Scenario: successfully update a tracks rating (default 0-unrated)
    When I fill in "rating" with "5"
      And I press the "Update Rating" button
    Then I should be on the "ratings" index page
      And I should see "Rating successfully updated"
      And I should see "5"

  Scenario: unsuccessfully update a tracks rating (default 0-unrated)
    When I fill in "rating" with "-2"
      And I press the "Update Rating" button
    Then I should be on the "Edit Rating" page
      And I should see "Error"
