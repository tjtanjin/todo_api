Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'authenticate', to: 'authentication#authenticate'
      post 'password/forgot', to: 'passwords#forgot'
      post 'password/reset', to: 'passwords#reset'
      resources :users do
      	put 'setnotifications', to: 'users#setnotifications'
        resources :tasks
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
