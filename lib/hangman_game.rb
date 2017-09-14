class HangmanGame

	attr_accessor(
		:word, 
		:output, 
		:correct_guesses,
		:wrong_guesses, 
		:repeat_guesses,
		:invalid_guesses, 
		:attempts_at_cheating,
	)

	def self.total_words
		File.foreach("lib/words").count
	end

	def self.get_random_word(word_num=nil)
		rnd = (word_num.nil?) ?
			Random.new.rand(self.total_words) : word_num
		count = 0
		word_in_file = ""
		File.foreach("lib/words") do |line|
			if count == rnd
				word_in_file = line.chomp
				break
			end
			count += 1
		end
		word_in_file
	end

	def initialize(word=nil)
		random_word = self.class.get_random_word
		@word = word.nil? ? random_word : word
		@output = output
		@correct_guesses = ""
		@wrong_guesses = ""
		@repeat_guesses = 0
		@invalid_guesses = 0
		@attempts_at_cheating = 0
	end

	def output
		@output = @word.gsub(/[^-#{@correct_guesses} ]/, '_')
	end

	def guess(letter)
		result = ""
		if letter.nil? || letter.strip.empty?
			result = ""
		else
			letter = letter.downcase.strip
			if letter.match(/^[A-Za-z]$/).nil?
				result = invalid
			elsif already_guessed? letter
				result = repeated
			else
				result = letter
				if @word.include? letter
					@correct_guesses << letter
				else
					@wrong_guesses << letter
				end
			end
		end
		result
	end

	def check_status
		if game_over?
			:nihilism
		elsif @wrong_guesses.length >= 5
			:lose
		elsif @word.eql? output
			:win
		else
			:play
		end
	end

	def cheated
		@attempts_at_cheating += 1
		case @attempts_at_cheating
		when 1
			"Nice try."
		else
			:nihilism
		end
	end

	def repeated
		@repeat_guesses += 1
		case @repeat_guesses
		when 1
			"I already guessed that."
		when 2
			"I must be getting senile."
		when 3
			"Where am I?"
		when 4
			"Age is just a number."
		when 5
			@correct_guesses = ""
			"...I forgot."
		else
			:nihilism
		end
	end

	def invalid
		@invalid_guesses += 1
		case @invalid_guesses
		when 1
			"Gibberish."
		when 2
			"Hocus pocus."
		when 3
			"Humpty Dumpty sat on a wall."
		else
			:nihilism
		end
	end

	def already_guessed? letter
		@correct_guesses.include?(letter) || 
			@wrong_guesses.include?(letter)
	end

	def game_over?
		@repeat_guesses >= 6 || 
			@invalid_guesses >= 4 ||
			@attempts_at_cheating >= 2
	end



end