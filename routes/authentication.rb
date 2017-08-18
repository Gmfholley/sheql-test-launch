def set_user_session

end

get '/login' do
  # Page where user can log in
end

get '/authenticate' do
  # Request authorization
end

get '/authenticated' do
  # Exchange token with Google
  user_credentials.code = params[:code] if params[:code]
  user_credentials.fetch_access_token!

  # set user tokens into session
  set_user_session

  # use user tokens to request their profile information
  info_service = Google::Apis::Oauth2V2::Oauth2Service.new
  info = info_service.get_userinfo(options: { authorization: user_credentials.access_token })

  # save profile information to session
  session[:email] = info.email
  session[:family_name] = info.family_name
  session[:given_name] = info.given_name
  session[:gender] = info.gender
  session[:name] = info.name
  session[:picture] = info.picture

  # You could also choose to create/save some of the information to the database instead
  # Only use once your user model is set up
  #
  #  user = User.find_or_initialize_by(email: info.email)
  #  user.picture = info.picture
  #  user.name = "#{info.given_name} #{info.family_name}"
  #  user.save
  #  session[:current_user_id] = user.id
  
  redirect to('/')
end

get '/logout' do
  # Clear the session and redirect to where user can log in

  session.clear
  redirect to('/login')
end
