class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]

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

  private

    def set_task
      @stage = Stage.find(params[:stage_id])
      @task = @stage.tasks.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def tasks_params
      params.permit(:title, :status, :user_id )
    end
end
