Rails.application.routes.draw do
  root 'users#index'
  get 'auth/pocket' => 'users#login'
  get 'callback' => 'users#new'
  get 'auth/logout' => 'users#logout'
end
