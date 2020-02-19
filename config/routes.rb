Rails.application.routes.draw do
  devise_for :users
  scope :api, defaults: { format: :json } do
    resources :categories, only: :index do
      resources :stages, only: :index do
        resources :tasks do
          member do
            get 'mark_as_completed'
            get 'start_task'
          end
        end
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
