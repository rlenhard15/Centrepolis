class StagesController < ApplicationController
  before_action :set_sub_category, only: :index

  # GET /stages
  def index
    @stages = @sub_category.stages

    render json: @stages.to_json(methods: :tasks_for_category)
  end

  private
  def set_sub_category
    @category = Category.find(params[:category_id])
    @sub_category = @category.sub_categories.find(params[:sub_category_id])
  end
end
