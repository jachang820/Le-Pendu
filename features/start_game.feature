Feature: start game

  As a player
  So I can play Hangman
  I want to start a new game

Scenario: I start a new game

  Given I am on the home page
  And I press "Continue"
  Then I should see "Help me recall the spell"
  And I press "Restart"
  Then I should see "Help me recall the spell"