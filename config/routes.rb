Rails.application.routes.draw do
  apipie
  devise_for :users, skip: %i[sessions registrations passwords]
  devise_scope :user do
    post '/users/sign_in', to: 'users/sessions#create'
    post '/users/sign_up', to: 'users/registrations#create'
    put '/users/password', to: 'users/passwords#update'
  end

  scope :api, defaults: { format: :json } do
    resources :notifications, only: :index do
      put :mark_as_readed, on: :member
      put :mark_as_readed_all, on: :collection
    end
    resources :tasks do
      put :mark_task_as_completed, on: :member
    end
    resources :startups, only: %i[index create]
    resources :members, only: %i[index create], module: 'admins'
    resources :admins, only: %i[index create], module: 'admins'
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
