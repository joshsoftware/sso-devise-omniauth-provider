OauthProviderDemo::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'registrations',
                                       :sessions => 'sessions'}
  # omniauth client stuff
  match '/auth/:provider/callback', :to => 'authentications#create'
  match '/auth/failure', :to => 'authentications#failure'

  # Provider stuff
  match '/oauth/authorize' => 'auth#authorize'
  match '/oauth/access_token' => 'auth#access_token'
  match '/oauth/user' => 'auth#user'

  root :to => 'auth#welcome'
end
