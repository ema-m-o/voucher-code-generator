Rails.application.routes.draw do
  resources :voucher_codes do
    post :validate, on: :collection
  end
  root 'pages#main'
end
