Rails.application.routes.draw do

  root "pages#index"
  
  get '/blog', to: 'pages#blog'
  get '/admin', to: 'admins#index'
  get 'admin/users', to: 'admins#users'
  get 'admin/user/:id', to: 'admins#show', as: 'admin_user'
  get 'admin/accounts', to: 'admins#accounts'
  get 'admin/transactions', to: 'admins#transactions'
  get 'admin/cards', to: 'admins#cards'
  get 'admin/activations', to: 'admins#activation'
  get 'admin/isactive/:id', to: "admins#active", as: "admin_isactive"
  get 'admin/reverse_tnx', to: 'admins#reverse_tnx', as: 'revert_tnx'
  devise_for :users,controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do 
    get '/users/sign_out' => 'devise/sessions#destroy'  
    get 'users/profile', to: "profiles#show" 
    get 'users/notification', to: "notifications#index" 
    resources :accounts do
      resources :transactions, only: [:index,:show]
      resources :deposits, only: [:new, :create]
      resources :card_transfers, only: [:new, :create]
      resources :cards, only: [:new, :create,:show] do
        get '/setpin', to: 'cards#set_pin'
        post '/save_pin', to: 'cards#save_pin'
      end
      scope(path_names: { new: 'new'}) do
        resources :beneficiaries, path: 'beneficiarien',only: [:new, :create,:show]
      end
    end
  end
  
end
