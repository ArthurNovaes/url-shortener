Rails.application.routes.draw do
  resources :users

  get '/users/:id/stats', to: 'users#stats', as: :stats

  resources :urls

  resources :stats
end
