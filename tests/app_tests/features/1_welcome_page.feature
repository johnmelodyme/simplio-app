Feature: Main Page
  Welcome Page

  Scenario: Checking Welcome Page

    Given I wait until the element of type "ElevatedButton" is present
    When I expect the text "Start using app" to be present
    Then I expect the text "Log in" to be present