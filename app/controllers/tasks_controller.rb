class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]
  before_action :set_stage, only: [:index, :create]

  def index
    @tasks = @stage.tasks
    render json: @tasks
  end

  def show
    render json: @task
  end

  def create
    @task = @stage.tasks.new(tasks_params)
    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end


  def update
    if @task.update(tasks_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
  end

  def mark_as_completed; end

  def start_task; end

  private

    def set_task
      @task = set_stage.tasks.find(params[:id])
    end

    def set_stage
      @category = Category.find(params[:category_id])
      @sub_category = @category.sub_categories.find(params[:sub_category_id])
      @stage = @sub_category.stages.find(params[:stage_id])
    end

    # Only allow a trusted parameter "white list" through.
    def tasks_params
      params.permit(:title, :status, :user_id )
    end
end
