Tolk::Engine.routes.draw do
  resources :locales do
    member do
      get :all
      get :updated
    end
  end
  
  resource :search
  
  root :to => 'locales#index'
end
