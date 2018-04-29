Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'regulators#get_grower_list'
  resources :buyers do
    collection do
      post '/create_without_id', to: 'buyers#create_without_id'
      post '/accept_offer', to: 'buyers#accept_offer'
      get '/get_offer_for_owning_request', to: 'buyers#get_offer_for_owning_request'
      get '/get_success_transaction', to: 'buyers#get_success_transaction'
      get '/get_barcode', to: 'buyers#get_barcode'
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
  resources :regulators do
    collection do
      post '/create_without_id', to: 'regulators#create_without_id'
      get '/get_grower_list', to: 'regulators#get_grower_list'
      post '/issue_certificate', to: 'regulators#issue_certificate'
      post '/cancel_certificate', to: 'regulators#cancel_certificate'
    end  
  end 
  resources :growers do
    member do 
      
    end  
    collection do
      post '/create_without_id', to: 'growers#create_without_id'
      get '/show_request_list', to: 'requests#index'
      post '/offer_to_buyer', to: 'growers#offer_to_buyer'
    end  
  end  
end
