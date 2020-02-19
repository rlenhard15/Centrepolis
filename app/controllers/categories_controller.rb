class CategoriesController < ApplicationController
<<<<<<< HEAD
  
=======

>>>>>>> master
  # GET /categories
  def index
    @categories = Category.all

    render json: @categories
  end
<<<<<<< HEAD
=======

>>>>>>> master
end
