require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangman_game'

class HangmanApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    word = HangmanGame.get_random_word
  	@game = session[:game] || HangmanGame.new(word)
  end

  after do
  	session[:game] = @game
  end

  get '/' do
    redirect '/new'
  end

  get '/new' do
    session[:muted] = "true"
    @wallpaper = "game"
  	erb :new
  end

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

  put '/game' do
    session[:muted] = params[:muted].to_s
  end

  post '/guess' do
    letter = params[:guess].to_s.downcase.gsub(/[\s]/, '')[0]
    current_output = @game.output
    flash.next[:message] = @game.guess letter
    flash.next[:guess_status] = "other"
    if flash.next[:message].length == 2
      flash.next[:guess_status] = (current_output == @game.output) ?
       "wrong" : "correct"
    end
    session[:num_wrong] += 1 if flash.next[:guess_status] == "wrong"
    redirect '/game'
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