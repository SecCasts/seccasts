Rails.application.routes.draw do
  
  resources :home

  resources :sessions do
    collection do
      get "step_two"
      post "login"
    end
  end
  
  root :to => "sessions#new"
  
end
