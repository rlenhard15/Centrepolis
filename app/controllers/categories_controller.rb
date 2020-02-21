class CategoriesController < ApplicationController

  # GET /categories
  def index
    @categories = Category.all

    render json: @categories.to_json(methods: [:list_of_sub_categories, :status_of_category, :list_of_stages, ])
  end
end
