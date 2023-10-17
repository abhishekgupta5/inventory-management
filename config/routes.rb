Rails.application.routes.draw do
  root to: 'products#index'
  get 'sign_in', to: 'sessions#new', as: :sign_in
  post 'sign_in', to: 'sessions#create'
  delete 'sign_out', to: 'sessions#destroy', as: :sign_out

  resources :employees, only: :index
  resources :addresses, only: %i[show edit update]
  resources :orders, only: :show do
    resource :fulfill, only: [:create]
    resource :return, only: [:create]
  end

  resources :products do
    resource :receive, only: [:create]
    resource :receive_return, only: [:create]
  end
end
