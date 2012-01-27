Tolk::Engine.routes.draw do
  resources :locales do
    member do
      get :all
      get :updated
      get :missing
    end
    
    resources :phrases do
      collection do
        post :translate
      end
    end
  end
  
  resource :search
  
  root :to => 'locales#index'
end
