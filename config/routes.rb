Rails.application.routes.draw do
  devise_for :users
  root to: "games#index"
  resources :games do
    resources :taggings, only: [:create, :destroy]
    member do
      delete :delete_image_attachment
    end
  end
end
