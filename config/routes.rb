Rails.application.routes.draw do
  root 'pages#home'

  devise_for :users

  resources :groups do
    resources :memberships
    resources :exchanges, only: %i[ create show ]
  end

  get "about" => "pages#about"
end
