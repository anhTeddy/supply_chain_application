Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'requests#index'
  resources :buyers do
    collection do
      post '/create_without_id', to: 'buyers#create_without_id'
    end  
  end
  resources :requests do
    collection do
      post '/create_without_id', to: 'requests#create_without_id'
    end  
  end
  resources :offers do
    collection do
      post '/create_without_id', to: 'offers#create_without_id'
    end  
  end
  resources :growers do
    member do 
      
    end  
    collection do
      get '/show_request_list', to: 'requests#index'
      post '/offer_to_buyer', to: 'growers#offer_to_buyer'
    end  
  end  
end
