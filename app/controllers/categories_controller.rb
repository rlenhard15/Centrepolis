class CategoriesController < ApplicationController

  # GET /categories
  def index
    @categories = Category.all

    render json: @categories.to_json(include: {sub_categories: {include: :stages}})
  end
end
