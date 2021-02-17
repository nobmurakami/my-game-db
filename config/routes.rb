Rails.application.routes.draw do
  devise_for :users
  root to: "games#index"
  resources :games do
    member do
      delete :delete_image_attachment
    end
    resources :taggings, only: [:create, :destroy]
    resource :lists, only: [:destroy] do
      collection do
        post 'want'
        post 'playing'
        post 'played'
      end
    end
    resource :favorites, only: [:create, :destroy]
  end
  resources :users, only: [:show] do
    member do
      get 'want-to-play'
      get 'playing'
      get 'played'
      get 'favorite'
    end
  end
  resources :genres, only: [:show]
  resources :platforms, only: [:show]
  resources :tags, only: [:show]
  resources :companies, only: [:show]
  resources :contacts, only: [:new, :create]
end
