Feature: Main Page
  Forgot Password Page

  Scenario: Checking Forgot Password Page

    Then I wait until the element of type "TextButton" is present
    And I tap the label that contains the text "Log in"
    When I expect the text "Log in" to be present within 10 seconds
    And I tap the button with the key: "sign-in-screen-reset-password-button"
    Then I expect the text "Please enter your email address associated with your account to receive a link for resetting your password." to be present within 10 seconds
    When I fill the "themed-text-form-field" field with "bob.gmail.com"
    And I tap the button with the key: "reset-screen-submit-button"
    Then I expect the text "Link was sent to bob.gmail.com" to be absent within 10 seconds
    When I fill the "themed-text-form-field" field with ""
    And I fill the "themed-text-form-field" field with "bob@wp.pl"
    And I wait 1 seconds
    And I tap the button with the key: "reset-screen-submit-button"
    Then I wait until the "send_forgot_password_popup" is present
    Then I expect the popup "send_forgot_password_popup" to be present within 10 seconds