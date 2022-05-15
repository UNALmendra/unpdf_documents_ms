Rails.application.routes.draw do
  resources :documents
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/documents_user/:user', to: 'documents#documents_of_user'
  
  # Defines the root path route ("/")
  # root "articles#index"
end
