Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
  end

  resources :urls do
  end

  resources :stats do
  end
end
