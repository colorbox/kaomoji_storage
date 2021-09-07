Rails.application.routes.draw do
  root 'kaomojis#index', as: :root

  resources :kaomojis, only: :index do
    resource :select, only: :update, controller: 'kaomoji_select'
  end
end
