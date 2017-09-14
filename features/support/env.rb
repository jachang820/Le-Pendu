# Generated by cucumber-sinatra. (2017-09-09 22:07:52 -0700)
require 'simplecov'

ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', '..', 'app.rb')

require 'capybara'
require 'capybara/cucumber'
require 'rspec'
require 'byebug'

Capybara.app = HangmanApp

class HangmanAppWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
end

World do
  HangmanAppWorld.new
end
