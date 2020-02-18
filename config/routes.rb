Rails.application.routes.draw do
  scope :api, defaults: { format: :json } do
    resources :categories, only: :index do
      resources :stages, only: :index
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
