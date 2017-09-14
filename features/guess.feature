Feature: guessing letters

  As a player playing Hangman
  So that I can make progress towards the goal
  I want to see the status of my guesses

Scenario: guess correct letter

  Given I start a new game with word "dasein"
  When I guess "d"
  Then the word should read "d_____"
  And I should see nothing on the wrong guess list

Scenario: guess wrong letter

  Given I start a new game with word "dasein"
  When I guess "u"
  Then the word should read "______"
  And I should see "u" on the wrong guess list

Scenario: make repeated guesses

  Given I start a new game with word "dasein"
  When I make the following guesses: a,a
  Then the word should read "_a____"
  And I should see nothing on the wrong guess list
  And I should see "I already guessed that."
  When I guess "a"
  Then I should see "I must be getting senile."
  When I guess "a"
  Then I should see "Where am I?"
  When I guess "a"
  Then I should see "I forgot what I was doing."
  And the word should read "______"
  When I guess "a"
  Then I should see "Age is just a number."
  And I should see nothing on the wrong guess list

Scenario: make invalid guesses

  Given I start a new game with word "dasein"
  When I guess "1"
  Then the word should read "______"
  And I should see nothing on the wrong guess list
  And I should see "Gibberish."
  When I guess "."
  Then the word should read "______"
  And I should see nothing on the wrong guess list
  And I should see "Hocus pocus."
  When I guess "/"
  Then the word should read "______"
  And I should see nothing on the wrong guess list
  And I should see "Humpty dumpty sat on a wall."

Scenario: guess letters that occur more than once

  Given that I start a new game with word "elemental"
  When I guess "e"
  Then the word should read "e_e_e____"
  And I should see nothing on the wrong guess list

Scenario: multiple guesses

  Given that I start a new game with word "a-priori"
  When I make the following guesses: a,i,r,y,e,t,p,c
  Then the word should read "a-pri_ri"
  And I should see "yetp" on the wrong guess list

Scenario: cheat by typing winning uri in browser

  Given that I start a new game with word "cheater"
  When I change the url to the win game page
  Then I should see "Nice try."