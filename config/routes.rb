Rails.application.routes.draw do
  apipie
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  authenticate :admin_user do
    mount Sidekiq::Web => '/sidekiq'
  end
  Sidekiq::Web.set :session_secret, Rails.application.credentials[:secret_key_base]

  namespace :api do
    namespace :v1 do

      resources :decks do
        get "by_name/:name", on: :collection, action: "by_name"
        get "random/:amount", on: :collection, action: "random"
      end

      resources :sets do
        resources :cards
      end
      resources :cards
    end
  end

  resources :rules
  resources :categories
  resources :profiles

  resources :sets do
    resources :cards do
      get :synergy, on: :member
      get :autocomplete_card_title, on: :collection
    end
  end

  resources :cards do
    get :synergy, on: :member
    get :autocomplete_card_title, on: :collection
  end

  resources :news
  resources :faqs
  resources :decks_users

  resources :virtual_decks do
    post :import, on: :collection
  end

  resources :api_keys

  resources :conversations do

    resources :messages
  end

  resources :users do
    resources :decks
  end
  resources :decks do
    resources :faqs
    get :synergy, on: :member

    get :list, on: :member
    get :sas, on: :member
    get :image, on: :member
    get :compare, on: :member
    get :tags, on: :member
    get :delayed_refresh, on: :member

    get :new_card_filter, on: :collection
    get :autocomplete_deck_name, on: :collection
    get :random, on: :collection
    get :mine, on: :collection
  end

  resources :pages do
    get :by_id, on: :member
  end

  resources :games

  resources :stats
  root to: "cards#index"
end
