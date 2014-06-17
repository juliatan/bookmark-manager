# require only the gems / files not needed in testing
require 'sinatra'
require 'data_mapper'

env = ENV["RACK_ENV"] || "development"

# we are telling DataMapper to use a postgres database on localhost.
# The name will be bookmark_manager_test or bookmark_manager_development depening
# on the environment.
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
# default here is the default adaptor for this type of database (postgres)
# the URL shown is the URL for the database

# require all the Database Classes in our app
require './lib/link' # this needs to be done after DataMapper is initialised
require './lib/tag'

# After declaring your models, you should finalise them (when they are checked
# for consistency)
DataMapper.finalize

# However, the database tables don't exist yet. Let's tell DataMapper to
# create them.
DataMapper.auto_upgrade!
# auto_upgrade makes non-destructive changes. If your tables don't exist, they will be created
# but if they do and you changed your schema (e.g. changed the type of one of the properties)
# they will not be upgraded because that'd lead to data loss.
# To force the creation of all tables as they are described in your models, even if this
# leads to data loss, use auto_migrate:
# DataMapper.auto_migrate!
# Finally, don't forget that before you do any of that stuff, you need to create a database first.

get '/' do
  @links = Link.all
  erb :index
end
# .all is a method from DataMapper that takes all lines in database and creates instance variables
# @links will be an array

post '/links' do
  url = params["url"]
  title = params["title"]

  tags = params["tags"].split(" ").map do |tag|
    #this will either find it or create it if it doesn't exist
    Tag.first_or_create(:text => tag)
  end
  # note that we are passing an array of instances to Link, rather than just text
  # because a tag is a database record of ID and text

  Link.create(:url => url, :title => title, :tags => tags)
  redirect to ('/')
end
# .create is a method from DataMapper that creates a new line in the database