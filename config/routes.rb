# frozen_string_literal: true

Rails.application.routes.draw do
  root 'components#index', via: :all

  # All the Api endpoints must be under /api/v1 and must have an extension .json.
  namespace :api do
    namespace :v1 do
      resources :sessions, only: %i[index create] do
        collection do
          delete 'signout', to: 'sessions#destroy'
        end
      end
      resources :users, only: %i[index create update destroy] do
        member do
          delete :purge_avatar
        end
      end
      resources :rooms, only: %i[show index create destroy], param: :friendly_id do
        member do
          post '/start', to: 'rooms#start', as: :start_meeting
          post '/shared_access', to: 'rooms#shared_access'
          get '/shared_users', to: 'rooms#shared_users'
          get '/shareable_users', to: 'rooms#shareable_users'
          post '/delete_shared_access', to: 'rooms#delete_shared_access'
          get '/recordings', to: 'rooms#recordings'
        end
      end
      resources :recordings, only: [:index]
    end
  end
  match '*path', to: 'components#index', via: :all, constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  } # Enable CSR for full fledged http requests.
end
