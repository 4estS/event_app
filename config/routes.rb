Rails.application.routes.draw do
  get "dashboard/show"
  root "pages#index"

  resource :guest_location, only: [ :new, :create, :destroy ]

  # Sign up (alias + RESTful routes)

  get "sign-up", to: "users#new", as: "sign_up"
  resources :users, only: [ :new, :create, :show ]

  # Sign in / out
  get  "sign_in",  to: "sessions#new"
  post "sign_in",  to: "sessions#create"
  delete "sign_out", to: "sessions#destroy"

  # static Pages
  get "dashboard", to: "dashboard#show"
  get "/home", to: "pages#home", as: :home

  # Event post routes
  resources :events, param: :slug

  resources :tags, only: [] do
    collection do
      get :autocomplete
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
