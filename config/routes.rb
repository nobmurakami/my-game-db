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
  end
  resources :users, only: [:show]
end
