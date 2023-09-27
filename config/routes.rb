Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    devise_for :users, controllers: {sessions: "users/sessions", registrations: "users/registrations"}
    root "static_pages#home"
    get "order", to: "orders#show"
    get "order-history", to: "orders#index"
    get "orders/delete_item", to: "orders#delete_item"
    get "orders/delete", to: "orders#delete"
    resources :categories, param: :slug, only: :show
    resources :cuisines, param: :slug, only: %i(index show)
    namespace :admin do
      resources :cuisines, param: :slug, except: :show do
        resources :options, only: %i(create new destroy edit update)
      end
      resources :categories, param: :slug
      resources :orders, only: %i(index show destroy update)
      resource :dashboard, only: [:show], controller: "dashboard", as: "custom_dashboard"
    end
    resources :options, only: %i(create new)
    resources :order_items, only: %i(create new)
    resources :orders, only: %i(new create destroy)
    resources :notifications, only: :index
  end
end
