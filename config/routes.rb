Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "signup", to: "users#new"
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    resources :users, only: :create
    resources :categories, param: :slug, only: :show
    resources :cuisines, param: :slug, only: %i(index show)

    namespace :admin do
      resources :cuisines
    end
  end
end
