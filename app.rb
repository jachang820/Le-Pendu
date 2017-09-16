require 'sinatra/base'
require 'sinatra/flash'
require 'json'
require './lib/hangman_game'

class HangmanApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  helpers do
    # Given letter, populate all fields necessary to draw html
    def guess(letter)
      letter = letter.to_s.downcase.gsub(/[\s]/, '')[0]
      current_output = @game.output
      flash.next[:message] = @game.guess letter
      flash.next[:guess_status] = "other"
      if flash.next[:message].length == 2
        flash.next[:guess_status] = (current_output == @game.output) ?
         "wrong" : "correct"
      end
      session[:num_wrong] += 1 if flash.next[:guess_status] == "wrong"
    end
  end

  # Maintain session or start new game if session is lost
  before do
    word = HangmanGame.get_random_word
  	@game = session[:game] || HangmanGame.new(word)
  end

  # Restore session
  after do
  	session[:game] = @game
  end

  get '/' do
    redirect '/new'
  end

  get '/new' do
    # Start game with sound off
    session[:muted] = "true"
    # Load background image
    @wallpaper = "game"
  	erb :new
  end

  # PUT requests are used to save sound preferences with ajax
  put '/new' do
    session[:muted] = params[:muted].to_s
  end

  post '/create' do
    word = HangmanGame.get_random_word
    @game = HangmanGame.new(word)
    flash.next[:guess_status] = "new"
    session[:num_wrong] = 0
    redirect '/game'
  end

  get '/game' do
    @wallpaper = "game"
    state = @game.check_status
    unless state == :play
      redirect '/' + state.to_s
    end
    erb :game
  end

  # Store sound preferences with ajax
  put '/game' do
    session[:muted] = params[:muted].to_s
  end

  post '/guess' do
    guess(params[:guess])
    redirect '/game'
  end

  # Send data back to ajax using json
  # When guessing with a large screen and Javascript enabled
  post '/guess.json' do
    guess(params[:guess])
    content_type :json
    { :num_wrong => session[:num_wrong],
      :guess_status => flash.next[:guess_status],
      :message => flash.next[:message].to_s,
      :output => @game.output,
      :state => @game.check_status.to_s
      }.to_json
  end

  get '/win' do
    @wallpaper = "win"
  	unless @game.check_status == :win
      flash[:message] = @game.cheated
  		redirect '/nihilism' if @game.check_status == :nihilism
      redirect '/game'
  	end
  	erb :win
  end

  put '/win' do
    session[:muted] = params[:muted].to_s
  end

  get '/lose' do
    @wallpaper = "game"
  	unless @game.check_status == :lose
  		redirect '/game'
  	end
  	erb :lose
  end

  put '/lose' do
    session[:muted] = params[:muted].to_s
  end

  get '/nihilism' do
    @wallpaper = "nihilism"
  	unless @game.check_status == :nihilism
  		redirect '/game'
  	end
  	erb :nihilism
  end

  put '/nihilism' do
    session[:muted] = params[:muted].to_s
  end

end