Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new'
  end
  resources :voucher_codes do
    post :validate, on: :collection
  end
  root 'pages#main'
end

# Ym-NdLWM
