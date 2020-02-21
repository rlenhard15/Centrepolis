class StagesController < ApplicationController
  before_action :set_category, only: :index

  # GET /stages
  def index
    @stages = @category.list_of_stages

    render json: @stages.to_json(methods: :tasks_for_category)
  end

  private
  def set_category
    @category = Category.find(params[:category_id])
  end
end
