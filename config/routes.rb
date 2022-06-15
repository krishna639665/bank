Rails.application.routes.draw do

  root "pages#index"
  get '/blog', to: 'pages#blog'
  get '/admin', to: 'admins#index'
  get 'admin/users', to: 'admins#users'
  get 'admin/accounts', to: 'admins#accounts'
  devise_for :users
  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
    resources :accounts
  end
end
