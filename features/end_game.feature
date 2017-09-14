Feature: end game states

  As a player playing Hangman
  So I can get an endorphin rush as I beat this game
  I want to know when the game has ended

Scenario: game over because I guess the word

  Given I start a new game with word "gnosis"
  When I make the following guesses: n,s,i,o,g
  Then I should see "justice has been served."

Scenario: game over because I run out of guesses

  Given I start a new game with word "gnosis"
  When I make the following guesses: c,r,a,z,y
  Then I should see "who you could have saved."

Scenario: game over because you made too many repeated guesses

  Given I start a new game with word "gnosis"
  When I make the following guesses: z,z,z,z,z,z,z
  Then I should see "fantasy land"

Scenario: game over because you made too many invalid guesses

  Given I start a new game with word "gnosis"
  When I make the following guesses: .,.,.,.
  Then I should see "fantasy land"

Scenario: game over because you cheated twice

  Given I start a new game with word "gnosis"
  When I change the url to the win game page
  And I change the url to the win game page
  Then I should see "fantasy land"
  