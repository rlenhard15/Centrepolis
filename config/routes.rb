Rails.application.routes.draw do
  scope :api, defaults: { format: :json } do
<<<<<<< HEAD
    resources :categories, only: :index do
      resources :stages, only: :index do
        resources :tasks do
          collection do
            get 'mark_as_completed'
            get 'start_task'
          end
        end
      end
    end
=======
    resources :categories, only: :index
>>>>>>> master
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
