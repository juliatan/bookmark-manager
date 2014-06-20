get '/users/new' do
  # note the view is in views/users/new.erb
  # we need the quotes because otherwise
  # ruby would divide the symbol :users by the
  # variable new (which makes no sense)
  @user = User.new #needed since we created @user in the new user erb page
  erb :"users/new"
end

post '/users' do
  # we just initialize the object without saving it. It may be invalid.
  # note we make user an instance variable so that the user's email will be
  # included when the form is re-rendered if it was invalid
  @user = User.create( :email => params[:email],
                      :password => params[:password],
                      :password_confirmation => params[:password_confirmation],
                      :password_token => params[:password_token],
                      :password_token_timestamp => params[:password_token_timestamp])
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

get '/users/reset_password' do
  erb :"users/reset_password"
end

get '/users/reset_password/:token' do
  user = User.first(:password_token => params[:token])
  @token = params[:token]
  if user.password_token_timestamp + (60*60) > DateTime.now
    erb :'/users/set_password'
  else
    flash.now[:notice] = "The password token has expired"
    erb :"users/reset_password"
  end
end

get '/users/set_password' do
  erb :"users/set_password"
end

post '/users/delete_token' do
  user = User.first(:password_token => params[:token])

  if user
    user.update(:password_token => nil,
                :password => params[:password],
                :password_confirmation => params[:password_confirmation])
    user.save
    redirect to ('/sessions/new')
  else
    redirect to ('/sessions/new')
  end
end