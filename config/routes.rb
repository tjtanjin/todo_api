Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'authenticate', to: 'authentication#authenticate'
      post 'password/forgot', to: 'passwords#forgot'
      post 'password/reset', to: 'passwords#reset'
      post 'sendverification', to: 'users#sendverification'
      post 'verify', to: 'users#checkverification'
      post 'link', to: 'users#checktelegram'
      resources :users do
      	put 'setemailnotifications', to: 'users#setemailnotifications'
        put 'settelegramnotifications', to: 'users#settelegramnotifications'
        put 'settelegramhandle', to: 'users#settelegramhandle'
        resources :tasks
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
