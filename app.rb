require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangman_game'

class HangmanApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
  	@game = session[:game] || HangmanGame.new
  end

  after do
  	session[:game] = @game
  end

  get '/' do
    redirect '/new'
  end

  get '/new' do
  	erb :new
  end

  post '/create' do
    @game = HangmanGame.new
    redirect '/game'
  end

  post '/game' do
    state = @game.check_status
    unless state == :play
      redirect '/' + state.to_s
    end
    erb :game
  end

  post '/guess' do
    letter = params[:guess].to_s.downcase.gsub(/[\s]/, '')[0]
    params[:say] = @game.guess letter
    redirect '/game'
  end

  get '/win' do
  	unless @game.check_status == :win
      params[:say] = @game.cheated
  		redirect '/nihilism' if @game.check_status == :nihilism
      redirect '/game'
  	end
  	erb :win
  end

  get '/lose' do
  	unless @game.check_status == :lose
  		redirect '/game'
  	end
  	erb :lose
  end

  get '/nihilism' do
  	unless @game.check_status == :nihilism
  		redirect '/game'
  	end
  	erb :nihilism
  end

end