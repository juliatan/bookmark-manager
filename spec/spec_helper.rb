ENV["RACK_ENV"] = 'test' # because we need to know what database to work with

# this needs to be after ENV["RACK_ENV"] = 'test'
# because the server needs to know
# what environment it is running in: test or development.
# The environment determines what database to use
require 'server'

# places all requires into one place

# require 'capybara/rspec'
# # require './server'
# Capybara.app = Sinatra::Application # this runs Sinatra for you without you having to run Sinatra

# require 'rubygems'
# require 'data_mapper'
# require 'dm-postgres-adapter'