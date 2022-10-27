Feature: Main Page
  Welcome Page

  Scenario: Checking Welcome Page

    Given I wait until the element of type "TextButton" is present
    When I expect the text "Go to app" to be present
    Then I expect the text "Log in" to be present