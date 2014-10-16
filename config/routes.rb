Rails.application.routes.draw do
  root 'users#index'
  get 'auth/pocket' => 'users#login'
  get 'callback' => 'users#new'
  get 'auth/logout' => 'users#logout'
  get ':user/:tag' => 'tags#show'
  get ':user' => 'tags#index'
end
