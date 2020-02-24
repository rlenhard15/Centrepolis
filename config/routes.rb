Rails.application.routes.draw do
  devise_for :users
  scope :api, defaults: { format: :json } do
    resources :categories, only: :index do
      resources :sub_categories, only: :index do
        resources :stages, only: :index do
          resources :tasks
        end
      end
    end
  end
end
