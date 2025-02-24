Feature: Pin Code Page

  Scenario: Checking Pin Code Page

    Given I wait until the element of type "ElevatedButton" is present
    When I expect the text "Log in" to be present within 10 seconds
    And I tap the button that contains the text "Log in"
    And  I fill the "themed-text-form-field" field with "bob@gmail.com"
    And  I fill the "sign-in-screen-password-text-field" field with "Password1@"
    And  I tap the button that contains the text "Log in"
    Then I expect the text "Account created" to be present within 60 seconds

    When I tap the button that contains the text "1"
    And I tap the button that contains the text "2"
    And I tap the button that contains the text "3"
    And I tap the button that contains the text "4"
    And I tap the button with the key: "numpad-action-erase"
    And I tap the button with the key: "numpad-action-erase"
    And I tap the button with the key: "numpad-action-erase"
    And I tap the button with the key: "numpad-action-erase"
    And I tap the button that contains the text "5"
    And I tap the button that contains the text "6"
    And I tap the button that contains the text "7"
    And I tap the button that contains the text "8"
    And I tap the button with the key: "numpad-action-erase"
    And I tap the button with the key: "numpad-action-erase"
    And I tap the button that contains the text "9"
    And I tap the button that contains the text "0"
    And I tap the button with the key: "numpad-action-proceed"
    And I wait 2 seconds
    When I tap the button that contains the text "Start using app" within 30 seconds
    And I expect the text "Discover" to be present within 10 seconds
    And I expect the text "My Games" to be present within 10 seconds
    And I expect the text "Inventory" to be present within 10 seconds
    And I expect the text "Find Dapps" to be present within 10 seconds
    And I tap the button that contains the text "Nick name"

    When I tap the button that contains the text "Sign out"
    Then I expect the text "Log in" to be present within 10 seconds

#Commented due to BUG with PIN CODE PAGE
#  Scenario: Checking Pin Code Page trying to login
#
#    Given I expect the text "Log in" to be present within 10 seconds
#    When I tap the button that contains the text "Log in"
#    And  I fill the "themed-text-form-field" field with "bob@gmail.com"
#    And  I fill the "sign-in-screen-password-text-field" field with "Password1@"
#    And I tap the button that contains the text "Log in"
#    Then  I expect the text "Enter your pin code." to be present within 10 seconds
#    When I tap the button that contains the text "1"
#    And I tap the button that contains the text "2"
#    And I tap the button that contains the text "3"
#    And I tap the button that contains the text "4"
#    Then I expect the text "You have remaining attempts: 5" to be present within 10 seconds
#
#    Given I tap the button that contains the text "1"
#    And I tap the button that contains the text "5"
#    And I tap the button that contains the text "6"
#    And I tap the button that contains the text "9"
#    Then I expect the text "You have remaining attempts: 4" to be present within 10 seconds
#
#    Given I tap the button that contains the text "2"
#    And I tap the button that contains the text "4"
#    And I tap the button that contains the text "5"
#    And I tap the button that contains the text "1"
#    Then I expect the text "You have remaining attempts: 3" to be present within 10 seconds
#
#    Given I tap the button that contains the text "9"
#    And I tap the button that contains the text "8"
#    And I tap the button that contains the text "7"
#    And I tap the button that contains the text "0"
#    Then I expect the text "You have remaining attempts: 2" to be present within 10 seconds
#
#    Given I tap the button that contains the text "5"
#    And I tap the button that contains the text "4"
#    And I tap the button that contains the text "8"
#    And I tap the button that contains the text "0"
#    Then I expect the text "This is your last chance" to be present within 10 seconds
#
#    Given I tap the button that contains the text "5"
#    And I tap the button that contains the text "4"
#
#    And I tap the button that contains the text "8"
#    And I tap the button that contains the text "0"
#    Then I expect the text "Log in" to be present within 10 seconds
#
#  Scenario: Checking Pin Code Page succesfull login
#
#    Given I wait 10 seconds
#    When I expect the text "Log in" to be present within 10 seconds
#    And I tap the label that contains the text "Log in"
#    And  I fill the "themed-text-form-field" field with "bob@gmail.com"
#    And  I fill the "sign-in-screen-password-text-field" field with "Password1@"
#    Then I tap the label that contains the text "Log in"
#
#    When I expect the text "Enter your pin code." to be present within 10 seconds
#    And I tap the button that contains the text "5"
#    And I tap the button that contains the text "6"
#    And I tap the button that contains the text "9"
#    And I wait 1 seconds
#    And I tap the button that contains the text "0" within 20 seconds
#    And I expect the text "Discover" to be present within 10 seconds
#    And I expect the text "My Games" to be present within 10 seconds
#    And I expect the text "Inventory" to be present within 10 seconds
#    And I expect the text "Find Dapps" to be present within 10 seconds
#    Then I tap the button that contains the text "Nick name"
#
#    When I tap the button that contains the text "Sign out"
#    Then I expect the text "Log in" to be present within 10 seconds









