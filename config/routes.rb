Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'buyers#index'
  resources :buyers do
    collection do
      post '/create_without_id', to: 'buyers#create_without_id'
    end  
  end  
end
