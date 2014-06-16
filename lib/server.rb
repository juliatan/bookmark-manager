# require 'spec/spec_helper.rb'
require 'data_mapper'

env = ENV["RACK_ENV"] || "development"

# we are telling DataMapper to use a postgres database on localhost.
# The name will be bookmark_manager_test or bookmark_manager_development depening
# on the environment.
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
# default here is the default adaptor for this type of database (postgres)
# the URL shown is the URL for the database

require './lib/link' # this needs to be done after DataMapper is initialised

# After declaring your models, you should finalise them (when they are checked
# for consistency)
DataMapper.finalize

# However, the database tables don't exist yet. Let's tell DataMapper to
# create them.
DataMapper.auto_upgrade!
# auto_upgrade! reconcile what’s in the database already with the changes you want to make
