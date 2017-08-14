require 'simplecov'
#SimpleCov.start

ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', '..', 'app')

require 'capybara'
require 'capybara/cucumber'
require 'rspec'
require 'rack_session_access'
require 'byebug'

Capybara.app = HangmanApp
Capybara.app.configure do |app|
  app.use RackSessionAccess::Middleware
end

class HangpersonAppWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
end

World do
  HangmanAppWorld.new
end
