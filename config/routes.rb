Rails.application.routes.draw do

  root "pages#index"
  get '/blog', to: 'pages#blog'
  get '/admin', to: 'admins#index'
  get 'admin/users', to: 'admins#users'
  get 'admin/accounts', to: 'admins#accounts'
  get 'admin/transactions', to: 'admins#transactions'
  devise_for :users
  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
    resources :accounts do
      resources :transactions, only: [:index,:show,:new, :create]
    end
  end
end
