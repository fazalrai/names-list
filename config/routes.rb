Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :users

  # authenticated :user do
  #   get '/(:uuid)', to: 'pages#my_names'
  # end

  # resources :pages, only: [] do
  #   collection do
  #     get :my_names
  #   end
  # end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :names, only: %i[index create]
    end
  end

  root 'pages#home'
end
