Rails.application.routes.draw do
  apipie
  devise_for :users, skip: %i[sessions registrations passwords]
  devise_scope :user do
    post '/users/sign_in', to: 'users/sessions#create'
    # post '/users/sign_up', to: 'users/registrations#create'
    post '/users/password', to: 'users/passwords#create'
    put '/users/password', to: 'users/passwords#update'
    get '/users/resend_invite', to: 'users/invites#show'
  end

  scope :api, defaults: { format: :json } do
    resources :notifications, only: :index do
      put :mark_as_readed, on: :member
      put :mark_as_readed_all, on: :collection
    end
    resources :tasks do
      put :mark_task_as_completed, on: :member
      get :send_task_reminder, on: :member
    end
    resources :accelerators, only: %i[index create]
    resources :startups, only: %i[index create show update destroy]
    resources :members, only: :index, module: 'admins'
    resources :admins, only: %i[index], module: 'admins'
    resources :users, only: %i[create index destroy], module: 'admins' do
      collection do
        get :profile
        put :change_password
        put :update_profile
        put :update_email_notification
      end
    end
    resources :assessments, only: %i[index show] do
      resources :categories, only: %i[index show] do
        resources :sub_categories, only: :index do
          post :update_progress, on: :member
          resources :stages, only: :index
        end
      end
    end
  end
end
