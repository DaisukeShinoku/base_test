Rails.application.routes.draw do
  root 'homes#top'
  namespace :player do
    get '/signup', to: 'players#new'
    post '/signup', to: 'players#create'
    resources :players
  end
end
