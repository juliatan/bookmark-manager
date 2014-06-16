# places all requires into one place

require 'capybara/rspec'
require './server'
Capybara.app = Sinatra::Application # this runs Sinatra for you without you having to run Sinatra