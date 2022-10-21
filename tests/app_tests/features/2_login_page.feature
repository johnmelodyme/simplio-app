@blockedByBug
Feature: Main Page
  Login Page

  Scenario: Checking Login Page

    Given I wait 10 seconds
    When I expect the text "Sign in" to be present within 10 seconds
    And I tap the label that contains the text "Sign in"
    And I expect the text "Enter Simplio." to be present within 10 seconds
    And I expect the text "It's good to see you back." to be present within 10 seconds
    And I tap the label that contains the text "Sign in"
    And I expect the text "Please enter valid email address" to be present within 10 seconds
    Then I expect the text "Please enter valid password" to be present within 10 seconds

    #checking proper handling email validation

    When I fill the "themed-text-form-field" field with "bob.gmail.com"
    And  I tap the label that contains the text "Sign in"
    And  I expect the text "Please enter valid email address" to be present within 10 seconds
    Then I tap the button with tooltip "Back"

    When I tap the label that contains the text "Sign in"
    And  I fill the "themed-text-form-field" field with "bob@gmail"
    And  I tap the label that contains the text "Sign in"
    And  I expect the text "Please enter valid email address" to be present within 10 seconds
    Then I tap the button with tooltip "Back"

    When I tap the label that contains the text "Sign in"
    And  I fill the "themed-text-form-field" field with "Bob@gmail.com"
    And  I tap the label that contains the text "Sign in"
    And  I expect the text "Please enter valid email address" to be absent within 10 seconds
    Then I tap the button with tooltip "Back"

    When I tap the label that contains the text "Sign in"
    And  I fill the "themed-text-form-field" field with "bob@gmail.com"
    And  I tap the label that contains the text "Sign in"
    Then I expect the text "Please enter valid email address" to be absent within 10 seconds

      # Checking proper validation of password

    When I tap the label that contains the text "Sign in"
    And I fill the "password-text-field" field with "pass"
    And  I tap the label that contains the text "Sign in"
    And I expect the text "Please enter valid password" to be present within 10 seconds
    Then I tap the button with tooltip "Back"

    When I tap the label that contains the text "Sign in"
    And I fill the "password-text-field" field with "Pass"
    And  I tap the label that contains the text "Sign in"
    And  I expect the text "Please enter valid password" to be present within 10 seconds
    Then I tap the button with tooltip "Back"

    When I tap the label that contains the text "Sign in"
    And I fill the "password-text-field" field with "Password"
    And  I tap the label that contains the text "Sign in"
    And I expect the text "Please enter valid password" to be present within 10 seconds
    Then I tap the button with tooltip "Back"

    When I tap the label that contains the text "Sign in"
    And  I fill the "password-text-field" field with "Password1"
    And  I tap the label that contains the text "Sign in"
    And I expect the text "Please enter valid password" to be present within 10 seconds
    Then I tap the button with tooltip "Back"

    #go to the app woth propper password and login

    When I tap the label that contains the text "Sign in"
    And  I fill the "password-text-field" field with "Password1@"
    And  I fill the "themed-text-form-field" field with "bob@gmail.com"
    And  I expect the text "Please enter valid password" to be absent within 10 seconds
    Then I expect the text "Please enter valid email address" to be absent within 10 seconds