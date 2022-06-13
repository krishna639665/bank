Rails.application.routes.draw do

  root "pages#index"
  get '/blog', to: 'pages#blog'
  get '/admin', to: 'admins#index'
  devise_for :users
  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
  end
end
