# require only the gems / files not needed in testing
require 'sinatra'
require 'data_mapper'
# require 'rack-flash'
require 'sinatra/flash'

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
  @user = User.new #needed since we created @user in the new user erb page
  erb :"users/new"
end

enable :sessions
set :session_secret, 'super secret'
#Then, let's save the user ID in the session after it is created

# use Rack::Flash
register Sinatra::Flash

post '/users' do
  # we just initialize the object without saving it. It may be invalid.
  # note we make user an instance variable so that the user's email will be
  # included when the form is re-rendered if it was invalid
  @user = User.create( :email => params[:email],
                      :password => params[:password],
                      :password_confirmation => params[:password_confirmation])
  # let's try saving it - it will save if the model is valid.
  # the user.id will be nil if the user wasn't saved
  # because of password mismatch
  if @user.save
    session[:user_id] = @user.id
    redirect to ('/')
  # if it's not valid, we'll show the same form again
  else
    # .now required to ensure flash is served immediately
    # the .errors object contains all validation errors
    # .full_messages returns an array of all the errors as strings
    flash.now[:errors] = @user.errors.full_messages
    erb :"users/new"
  end
end