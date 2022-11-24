# frozen_string_literal: true

<<<<<<< HEAD
# BigBlueButton open source conferencing system - http://www.bigbluebutton.org/.
#
# Copyright (c) 2018 BigBlueButton Inc. and by respective authors (see below).
#
# This program is free software; you can redistribute it and/or modify it under the
# terms of the GNU Lesser General Public License as published by the Free Software
# Foundation; either version 3.0 of the License, or (at your option) any later
# version.
#
# BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License along
# with BigBlueButton; if not, see <http://www.gnu.org/licenses/>.

Rails.application.routes.draw do
  get '/health_check', to: 'health_check#all'

  # Error routes.
  match '/401', to: 'errors#unauthorized', via: :all, as: :unauthorized
  match '/404', to: 'errors#not_found', via: :all, as: :not_found
  match '/500', to: 'errors#internal_error', via: :all, as: :internal_error

  # Signin/Signup routes.
  get '/signin', to: 'sessions#signin', as: :signin
  get '/signup', to: 'sessions#new', as: :signup
  post '/signup', to: 'users#create', as: :create_user
  get '/ldap_signin', to: 'sessions#ldap_signin', as: :ldap_signin

  # Redirect to terms page
  match '/terms', to: 'users#terms', via: [:get, :post]

  # Admin resouces
  resources :admins, only: [:index]

  scope '/admins' do
    # Panel Tabs
    get '/rooms', to: 'admins#server_rooms', as: :admin_rooms
    get '/recordings', to: 'admins#server_recordings', as: :admin_recordings
    get '/site_settings', to: 'admins#site_settings', as: :admin_site_settings
    get '/room_configuration', to: 'admins#room_configuration', as: :admin_room_configuration
    get '/roles', to: 'admins#roles', as: :admin_roles
    # Manage Users
    get '/edit/:user_uid', to: 'admins#edit_user', as: :admin_edit_user
    post '/ban/:user_uid', to: 'admins#ban_user', as: :admin_ban
    post '/unban/:user_uid', to: 'admins#unban_user', as: :admin_unban
    post '/invite', to: 'admins#invite', as: :invite_user
    post '/approve/:user_uid', to: 'admins#approve', as: :admin_approve
    get '/reset', to: 'admins#reset', as: :admin_reset
    post '/undelete', to: 'admins#undelete', as: :admin_undelete
    post '/merge/:user_uid', to: 'admins#merge_user', as: :merge_user
    get '/merge_list', to: 'admins#merge_list', as: :merge_list
    # Site Settings
    post '/update_settings', to: 'admins#update_settings', as: :admin_update_settings
    post '/registration_method', to: 'admins#registration_method', as: :admin_change_registration
    post '/coloring', to: 'admins#coloring', as: :admin_coloring
    post '/clear_cache', to: 'admins#clear_cache', as: :admin_clear_cache
    post '/clear_auth', to: 'admins#clear_auth', as: :admin_clear_auth
    post '/log_level', to: 'admins#log_level', as: :admin_log_level
    # Room Configuration
    post '/update_room_configuration', to: 'admins#update_room_configuration', as: :admin_update_room_configuration
    # Roles
    post '/role', to: 'admins#new_role', as: :admin_new_role
    patch 'roles/order', to: 'admins#change_role_order', as: :admin_roles_order
    post '/role/:role_id', to: 'admins#update_role', as: :admin_update_role
    delete 'role/:role_id', to: 'admins#delete_role', as: :admin_delete_role
  end

  scope '/themes' do
    get '/primary', to: 'themes#index', as: :themes_primary
  end

  # Password reset resources.
  resources :password_resets, only: [:new, :create, :edit, :update]

  # Account activation resources
  scope '/account_activations' do
    get '/', to: 'account_activations#show', as: :account_activation
    get '/edit', to: 'account_activations#edit', as: :edit_account_activation
    post '/resend', to: 'account_activations#resend', as: :resend_email
  end

  # User resources.
  scope '/u' do
    # Handles login of greenlight provider accounts.
    post '/login', to: 'sessions#create', as: :create_session

    # Log the user out of the session.
    post '/logout', to: 'sessions#destroy'

    # Account management.
    get '/:user_uid/edit', to: 'users#edit', as: :edit_user
    get '/:user_uid/change_password', to: 'users#change_password', as: :change_password
    get '/:user_uid/delete_account', to: 'users#delete_account', as: :delete_account
    post '/:user_uid/edit', to: 'users#update', as: :update_user
    post '/:user_uid/change_password', to: 'users#update_password', as: :update_password
    delete '/:user_uid', to: 'users#destroy', as: :delete_user

    # All user recordings
    get '/:user_uid/recordings', to: 'users#recordings', as: :get_user_recordings
  end

  # Handles Omniauth authentication.
  match '/auth/:provider/callback', to: 'sessions#omniauth', via: [:get, :post], as: :omniauth_session
  get '/auth/failure', to: 'sessions#omniauth_fail'
  post '/auth/ldap', to: 'sessions#ldap', as: :ldap_callback

  # Users who can't create rooms
  get '/rooms', to: 'rooms#cant_create_rooms', as: :cant_create_rooms

  # Returns a list of users for the shared access list
  get '/shared_access_list', to: 'users#shared_access_list'

  # Room resources.
  resources :rooms, only: [:create, :show, :destroy], param: :room_uid, path: '/'

  # Join a room by UID
  post '/room/join', to: 'rooms#join_specific_room', as: :join_room

  # Extended room routes.
  scope '/:room_uid' do
    post '/', to: 'rooms#join'
    get '/room_settings', to: 'rooms#room_settings'
    post '/update_settings', to: 'rooms#update_settings'
    get '/current_presentation', to: 'rooms#current_presentation'
    post '/preupload_presentation', to: 'rooms#preupload_presentation'
    post '/remove_presentation', to: 'rooms#remove_presentation'
    post '/update_shared_access', to: 'rooms#shared_access', as: :room_shared_access
    delete '/remove_shared_access', to: 'rooms#remove_shared_access', as: :room_remove_shared_access
    get '/shared_users', to: 'rooms#shared_users', as: :room_shared_users
    post '/start', to: 'rooms#start', as: :start_room
    get '/logout', to: 'rooms#logout', as: :logout_room
    post '/login', to: 'rooms#login', as: :login_room
  end

  # Recording operations routes
  scope '/:meetingID' do
    # Manage recordings
    scope '/:record_id' do
      post '/', to: 'recordings#update', as: :update_recording
      patch '/', to: 'recordings#rename', as: :rename_recording
      delete '/', to: 'recordings#delete', as: :delete_recording
    end
  end

  root to: 'main#index'
=======
Rails.application.routes.draw do
  root 'components#index', via: :all
  mount ActionCable.server => '/cable'

  # External requests
  get '/auth/:provider/callback', to: 'external#create_user'
  get '/meeting_ended', to: 'external#meeting_ended'
  post '/recording_ready', to: 'external#recording_ready'

  # All the Api endpoints must be under /api/v1 and must have an extension .json.
  namespace :api do
    namespace :v1 do
      resources :sessions, only: %i[index create] do
        collection do
          delete 'signout', to: 'sessions#destroy'
        end
      end
      resources :users, only: %i[show create update destroy] do
        post '/change_password', to: 'users#change_password', on: :collection
        member do
          delete :purge_avatar
        end
      end
      resources :rooms, param: :friendly_id do
        member do
          get '/recordings', to: 'rooms#recordings'
          get '/recordings_processing', to: 'rooms#recordings_processing'
          get '/public', to: 'rooms#public_show'
          delete :purge_presentation
        end
      end
      resources :meetings, only: %i[], param: :friendly_id do
        member do
          post '/start', to: 'meetings#start'
          post '/status', to: 'meetings#status'
          get '/running', to: 'meetings#running'
        end
      end
      resources :room_settings, only: %i[show update], param: :friendly_id
      resources :recordings, only: %i[index update destroy] do
        collection do
          post '/update_visibility', to: 'recordings#update_visibility'
          get '/recordings_count', to: 'recordings#recordings_count'
        end
      end
      resources :shared_accesses, only: %i[create show destroy], param: :friendly_id do
        member do
          get '/shareable_users', to: 'shared_accesses#shareable_users'
        end
      end
      resources :env, only: :index
      resources :reset_password, only: :create do
        collection do
          post '/reset', to: 'reset_password#reset'
          post '/verify', to: 'reset_password#verify'
        end
      end
      resources :verify_account, only: :create do
        post '/activate', to: 'verify_account#activate', on: :collection
      end
      resources :site_settings, only: :show, param: :name
      resources :rooms_configurations, only: :index

      namespace :admin do
        resources :users, only: %i[update] do
          collection do
            get '/verified_users', to: 'users#verified_users'
            get '/pending', to: 'users#pending'
            get '/banned_users', to: 'users#banned_users'
            post '/:user_id/create_server_room', to: 'users#create_server_room'
          end
        end
        resources :server_recordings, only: %i[index]
        resources :server_rooms, only: %i[index destroy], param: :friendly_id do
          get '/resync', to: 'server_rooms#resync', on: :member
        end
        resources :site_settings, only: %i[index update], param: :name
        resources :rooms_configurations, only: :update, param: :name
        resources :roles
        resources :invitations, only: %i[index create]
        # TODO: Review update route
        resources :role_permissions, only: [:index] do
          collection do
            post '/', to: 'role_permissions#update'
          end
        end
      end

      namespace :migrations do
        post '/roles', to: 'external#create_role'
        post '/users', to: 'external#create_user'
        post '/rooms', to: 'external#create_room'
      end
    end
  end


  match '*path', to: 'components#index', via: :all, constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  } # Enable CSR for full fledged http requests.
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
end
