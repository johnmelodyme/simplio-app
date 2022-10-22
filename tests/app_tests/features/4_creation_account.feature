@blockedByBug
Feature: Main Page
  Create a new account page

  Scenario: Checking Creation of New Account

    Given I wait 10 seconds
    When I tap the label that contains the text 'Log in'
    And I expect the text 'Enter Simplio.' to be present
    And I tap the button with the key: 'sign-in-screen-create-account-button'
    And I expect the text 'Create a new account' to be present within 10 seconds
    And I expect the text 'Has at least 8 characters' to be present within 10 seconds
    And I expect the text 'Must include number' to be present within 10 seconds
    And I expect the text 'Must include special character' to be present within 10 seconds
    Then I expect the text 'Must include upper case character' to be present within 10 seconds

    When I fill the 'themed-text-form-field' field with 'bob.gmail.com'
    And  I tap the button with the key: 'password-text-field'
    And I expect the text 'Please enter valid email address' to be present within 10 seconds
    Then I fill the 'themed-text-form-field' field with ''

    When  I fill the 'themed-text-form-field' field with 'bob@gmail'
    And  I tap the button with the key: 'password-text-field'
    And I expect the text 'Please enter valid email address' to be present within 10 seconds
    Then I fill the 'themed-text-form-field' field with ''

    When  I fill the 'themed-text-form-field' field with 'Bob@gmail.com'
    And  I tap the button with the key: 'password-text-field'
    And I expect the text 'Please enter valid email address' to be absent within 10 seconds
    Then I fill the 'themed-text-form-field' field with ''

    When  I fill the 'themed-text-form-field' field with 'bob@gmail.com'
    And  I tap the label that contains the text 'Create account'
    And I expect the text 'Please enter valid email address' to be absent within 10 seconds
    Then Then I fill the 'themed-text-form-field' field with ''

    When I fill the 'password-text-field' field with 'pass'
    And I tap the button with the key: 'password-text-field-icon'
    And I tap the label that contains the text 'Create account'
    Then I expect the text 'Create a new account' to be present within 10 seconds

    When I fill the 'password-text-field' field with ''
    And I fill the 'password-text-field' field with 'password'
    And I tap the button with the key: 'password-text-field-icon'
    And I tap the label that contains the text 'Create account'
    Then I expect the text 'Create a new account' to be present within 10 seconds

    When I fill the 'password-text-field' field with ''
    And I fill the 'password-text-field' field with 'password1'
    And I tap the button with the key: 'password-text-field-icon'
    And I tap the label that contains the text 'Create account'
    Then I expect the text 'Create a new account' to be present within 10 seconds

    When I fill the 'password-text-field' field with ''
    And I fill the 'password-text-field' field with 'p@ssword1'
    And I tap the button with the key: 'password-text-field-icon'
    And I tap the label that contains the text 'Create account'
    Then I expect the text 'Create a new account' to be present within 10 seconds

    When I fill the 'password-text-field' field with ''
    And I fill the 'themed-text-form-field' field with 'bob10@gmail.com'
    And I fill the 'password-text-field' field with 'P@ssword1'
    Then I tap the button with the key: 'password-text-field-icon'
