require 'sinatra/base'
require 'sinatra/flash'

class HangmanApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  get '/' do
    "<!DOCTYPE html><html><head></head><body><h1>Hello World</h1></body></html>"
  end
end