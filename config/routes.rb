Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "signup", to: "users#new"
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    get "order", to: "orders#show"
    get "order-history", to: "orders#index"
    resources :users, only: %i(create edit update)
    get "orders/delete_item", to: "orders#delete_item"
    get "orders/delete", to: "orders#delete"
    resources :categories, param: :slug, only: :show
    resources :cuisines, param: :slug, only: %i(index show)
    namespace :admin do
      resources :cuisines, param: :slug, except: :show
      resources :categories, param: :slug
      resources :orders, only: %i(index show destroy update)
    end
    resources :options, only: %i(create new)
    resources :order_items, only: %i(create new)
    resources :orders, only: %i(new create)
  end
end
