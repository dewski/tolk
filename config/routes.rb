Tolk::Engine.routes.draw do
  resources :locales do
    member do
      get :all
      get :updated
      get :missing
    end
  end
  
  resource :search
  
  root :to => 'locales#index'
end
