Rails.application.routes.draw do
  root to: "games#index"
  resources :games, only: [:index, :new, :create, :show, :edit, :update]
end
