Rails.application.routes.draw do
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
end
