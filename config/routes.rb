Rails.application.routes.draw do
  devise_for :users
  root "welcome#index"
  resources :achievements do
  	resources :encouragements, only: [:new, :create]
  end
end
