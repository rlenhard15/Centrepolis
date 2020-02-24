class StagesController < ApplicationController
  before_action :set_sub_category, only: :index
  # GET /stages
  def index
    @stages = @sub_category.stages

    render json: @stages.to_json(methods: :tasks_for_stage)
  end


  private

  def set_sub_category
    @sub_category = SubCategory.find(params[:sub_category_id])
  end
end
