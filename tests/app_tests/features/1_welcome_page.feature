Feature: Main Page
  Welcome Page

  Scenario: Checking Welcome Page

    Given I wait 10 seconds
    When I expect the text "Go to app" to be present
    Then I expect the text "Log in" to be present