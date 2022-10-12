Rails.application.routes.draw do
  resources :users
  resources :payers
  resources :transactions, only: [:index, :create]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "/balance", to: "transactions#index"
  post "/add/:id", to: "transactions#create"
  post "user", to: "users#create"
  get "/usertransaction/:id", to: "transactions#show"
  get "/user/:id", to: "users#show"
  get "/userbalance/:id", to: "users#balance"
  post "/userspend/:id", to: "users#spend"
end
