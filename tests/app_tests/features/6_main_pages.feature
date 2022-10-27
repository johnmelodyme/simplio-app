Feature: Main Pages Checking

  Scenario: Checking Main Pages Of an APP

    Then I wait until the element of type "TextButton" is present
    When I expect the text "Log in" to be present within 10 seconds
    And I tap the label that contains the text "Log in"
    And  I fill the "themed-text-form-field" field with "bob@gmail.com"
    And I expect the text "Please enter valid email address" to be absent within 10 seconds
    And  I fill the "sign-in-screen-password-text-field" field with "Password1@"
    And I expect the text "Please enter valid password" to be absent within 10 seconds
    Then  I tap the label that contains the text "Log in"

    When I expect the text "Enter your pin code." to be present within 10 seconds
    And I tap the label that contains the text "5"
    And I tap the label that contains the text "6"
    And I tap the label that contains the text "9"
    And I wait 1 seconds
    And I tap the button that contains the text "0" within 20 seconds
    And I expect the text "Discover" to be present within 10 seconds
    And I expect the text "My Games" to be present within 10 seconds
    And I expect the text "Inventory" to be present within 10 seconds
    Then I expect the text "Find Dapps" to be present within 10 seconds

    When I expect the text "Games" to be present within 10 seconds
#    And I swipe up by 800 pixels on thee "games_list_table"
#    And I tap the button that contains the text "Games" within 10 seconds
#    And I swipe up by 800 pixels on the "games_list_table"
#    And  I expect the text "Search & add Games" to be present within 10 seconds
#    And I tap the button that contains the text "Coins" within 10 seconds
#    And I swipe up by 800 pixels on the "games_list_table"
#    And  I expect the text "Search & add Coins" to be present within 10 seconds
#    And I tap the button that contains the text "NFT" within 10 seconds
#    And I swipe up by 800 pixels on the "games_list_table"
#    Then  I expect the text "Search NFT" to be present within 10 seconds

    When I tap the button that contains the text "My Games" within 10 seconds
    # This step have to be changed in the feature.
    Then  I expect the text "GamesScreen screen placeholder" to be present within 10 seconds

    When I tap the button that contains the text "Inventory" within 10 seconds
    And  I expect the text "Inventory balance" to be present within 10 seconds
    And  I expect the text "Search & add Coins" to be present within 10 seconds
    And  I expect the text "Coins" to be present within 10 seconds
    And  I expect the text "NFT" to be present within 10 seconds
    Then  I expect the text "Transactions" to be present within 10 seconds

    When I tap the button that contains the text "NFT" within 10 seconds
    And  I expect the text "Search NFT" to be present within 10 seconds
    And I tap the button that contains the text "Transactions" within 10 seconds
    And  I expect the text "Search Transactions" to be present within 10 seconds

    Then I tap the button that contains the text "Nick name"
    And I tap the button that contains the text "Sign out"
    Then I expect the text "Log in" to be present within 10 seconds












