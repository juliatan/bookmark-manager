get '/sessions/new' do
  erb :"sessions/new"
end

post '/sessions/new' do
  email = params[:email]
  flash[:notice] = "Go check your email"
  
  user = User.first(:email => email)
  user.password_token = (1..64).map{ ('A'..'Z').to_a.sample }.join
  user.password_token_timestamp = Time.now
  user.save
  url = "http://localhost:9393/users/reset_password?token=#{user.password_token}"
  send_recovery_email(email,url)

  redirect to('/sessions/new') # since flash only works on second reload
end  

post '/sessions' do
  email, password = params[:email], params[:password]
  user = User.authenticate(email, password)
  if user
    session[:user_id] = user.id
    redirect to ('/')
  else
    flash[:errors] = "The email or password is incorrect"
    erb :"sessions/new"
  end
end

delete '/sessions' do
  flash[:notice] = "Goodbye!"
  session[:user_id] = nil
  redirect to ('/')
end