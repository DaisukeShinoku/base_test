Rails.application.routes.draw do
  root 'homes#top'

  namespace :player do
    get '/signup', to: 'players#new'
    post '/signup', to: 'players#create'
    get '/login', to: 'sessions#new'
    post '/login', to: 'sessions#create'
    delete '/login', to: 'sessions#destroy'
    resources :players, only: [:create, :show, :edit, :update]
  end

  namespace :team do
    get '/signup', to: 'teams#new'
    post '/signup', to: 'teams#create'
    get '/login', to: 'sessions#new'
    post '/login', to: 'sessions#create'
    delete '/login', to: 'sessions#destroy'
    resources :teams, only: [:create, :show, :edit, :update]
  end
end
