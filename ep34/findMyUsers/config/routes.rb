FindMyUsers::Application.routes.draw do
  root 'sessions#new'

  post '/sessions', to: 'sessions#create'
end
