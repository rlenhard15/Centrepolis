Rails.application.routes.draw do
  apipie
  devise_for :users, skip: %i[sessions registrations passwords]
  devise_scope :user do
    post '/users/sign_in', to: 'users/sessions#create'
    post '/users/sign_up', to: 'users/registrations#create'
    put '/users/password', to: 'users/passwords#update'
  end

  scope :api, defaults: { format: :json } do
    resources :customers, only: %i[index create], module: 'admins'
    resources :assessments, only: %i[index show] do
      resources :categories, only: :index do
        resources :sub_categories, only: :index do
          member do
            post :update_progress
          end
          resources :stages, only: :index do
            resources :tasks
          end
        end
      end
    end
  end
end
