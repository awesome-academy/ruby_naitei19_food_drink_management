Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "signup", to: "users#new"
    resources :users, only: [:create]
  end
end
