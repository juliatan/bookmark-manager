# require only the gems / files not needed in testing
require 'sinatra'
require 'data_mapper'

# require all the Database Classes in our app
require './lib/link' # this needs to be done after DataMapper is initialised
require './lib/tag'
require './lib/user'

require_relative 'helpers/application'
require_relative 'data_mapper_setup'

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

get '/tags/:text' do
  tag = Tag.first(:text => params[:text])
  # setting @links to be equal to the result from the tag ? tag.links : [] operator
  @links = tag ? tag.links : []
  erb :index
end

get '/users/new' do
  # note the view is in views/users/new.erb
  # we need the quotes because otherwise
  # ruby would divide the symbol :users by the
  # variable new (which makes no sense)
  erb :"users/new"
end

enable :sessions
set :session_secret, 'super secret'
#Then, let's save the user ID in the session after it is created
post '/users' do
  user = User.create( :email => params[:email],
                      :password => params[:password],
                      :password_confirmation => params[:password_confirmation])
  session[:user_id] = user.id
  redirect to ('/')
end