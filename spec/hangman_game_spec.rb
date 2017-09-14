require 'spec_helper'
require 'hangman_game'

describe HangmanGame do 

	def multiple_guesses(game, letters)
		letters.each_char do |letter|
			game.guess(letter)
		end
	end

	describe "get random word" do
		it "obtains the number of lines in word file" do
			num = HangmanGame.total_words
			expect(num).to eq(151)
		end
		it "retrieves a random line from the word file" do
			word = HangmanGame.get_random_word(0)
			expect(word).to eq('absolutism')
			word = HangmanGame.get_random_word(26)
			expect(word).to eq('didactic')
		end
	end

	describe "new" do
		it "returns a HangmanGame object" do
			@game = HangmanGame.new('good')
			expect(@game).to be_an_instance_of(HangmanGame)
			expect(@game.word).to eq('good')
			expect(@game.correct_guesses).to eq('')
			expect(@game.wrong_guesses).to eq('')
			expect(@game.repeat_guesses).to eq(0)
			expect(@game.invalid_guesses).to eq(0)
			expect(@game.attempts_at_cheating).to eq(0)
			expect(@game.output).to eq('____')
		end
		it "selects a random word" do
			@game = HangmanGame.new
			expect(@game).to be_an_instance_of(HangmanGame)
			expect(@game.word.length).to be >= 4
			expect(@game.correct_guesses).to eq('')
			expect(@game.wrong_guesses).to eq('')
			expect(@game.output).to eq(@game.word.gsub(/[A-Za-z]/, '_'))
			expect(@game.word).not_to eq('good')
		end
	end

	describe "guessing a word" do
		before :each do
			@game = HangmanGame.new('xylophone')
		end
		it "is a correct guess" do
			result = @game.guess('o')
			expect(result).to eq('o')
			expect(@game.word).to eq('xylophone')
			expect(@game.word.include? 'o').to eq(true)
			expect(@game.correct_guesses).to eq('o')
			expect(@game.wrong_guesses).to eq('')
			expect(@game.repeat_guesses).to eq(0)
			expect(@game.invalid_guesses).to eq(0)
			expect(@game.attempts_at_cheating).to eq(0)
			expect(@game.output).to eq('___o__o__')
		end
		it "is a wrong guess" do
			@game.guess('z')
			expect(@game.correct_guesses).to eq('')
			expect(@game.wrong_guesses).to eq('z')
			expect(@game.repeat_guesses).to eq(0)
			expect(@game.invalid_guesses).to eq(0)
			expect(@game.attempts_at_cheating).to eq(0)
			expect(@game.output).to eq('_________')
		end
		it "is a repeated guess" do
			multiple_guesses(@game, 'xzxxzz')
			expect(@game.correct_guesses).to eq('x')
			expect(@game.wrong_guesses).to eq('z')
			expect(@game.repeat_guesses).to eq(4)
			expect(@game.invalid_guesses).to eq(0)
			expect(@game.attempts_at_cheating).to eq(0)
			expect(@game.output).to eq('x________')
		end
		it "ignores spaces and nil" do
			multiple_guesses(@game, ' p h z a  ')
			expect(@game.correct_guesses).to eq('ph')
			expect(@game.wrong_guesses).to eq('za')
			expect(@game.repeat_guesses).to eq(0)
			expect(@game.invalid_guesses).to eq(0)
			expect(@game.attempts_at_cheating).to eq(0)
			expect(@game.output).to eq('____ph___')
			@game.guess(nil)
			expect(@game.correct_guesses).to eq('ph')
			expect(@game.wrong_guesses).to eq('za')
			expect(@game.repeat_guesses).to eq(0)
			expect(@game.invalid_guesses).to eq(0)
			expect(@game.attempts_at_cheating).to eq(0)
		end
		it "is an invalid guess" do
			multiple_guesses(@game, ' %!!')
			expect(@game.correct_guesses).to eq('')
			expect(@game.wrong_guesses).to eq('')
			expect(@game.repeat_guesses).to eq(0)
			expect(@game.invalid_guesses).to eq(3)
			expect(@game.attempts_at_cheating).to eq(0)
			expect(@game.output).to eq('_________')
		end
		it "is case insensitive" do
			multiple_guesses(@game, 'XYyUu')
			expect(@game.correct_guesses).to eq('xy')
			expect(@game.wrong_guesses).to eq('u')
			expect(@game.repeat_guesses).to eq(2)
			expect(@game.invalid_guesses).to eq(0)
			expect(@game.attempts_at_cheating).to eq(0)
		end
	end

	describe "game status" do
		before :each do
			@game = HangmanGame.new('xulu')
		end
		it "should be still in game" do
			multiple_guesses(@game, '  xuxx@%&uu u ')
			expect(@game.check_status).to eq(:play)
		end
		it "should be win when word is guessed" do
			multiple_guesses(@game, 'ulx')
			expect(@game.check_status).to eq(:win)
		end
		it "should be lose after 5 incorrect guesses" do
			multiple_guesses(@game, 'zprea')
			expect(@game.check_status).to eq(:lose)
		end
		it "should be nihilism after 6 repeated guesses" do
			multiple_guesses(@game, 'sssssss')
			expect(@game.check_status).to eq(:nihilism)
		end
		it "should be nihilism after 4 invalid guesses" do
			multiple_guesses(@game, '!@#$')
			expect(@game.check_status).to eq(:nihilism)
		end
	end

	describe "cheating" do
		it "should give warning after cheating once" do
			@game = HangmanGame.new("one two-three")
			expect(@game.output).to eq('___ ___-_____')
			msg = @game.cheated
			expect(msg).to eq('Nice try.')
		end
		it "should be nihilism after cheating twice" do
			@game = HangmanGame.new
			@game.cheated
			msg = @game.cheated
			expect(msg).to eq(:nihilism)
		end
	end
end
