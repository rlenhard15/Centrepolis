class TasksController < ApplicationController
  before_action :tasks_params, only: [:show, :update, :destroy]

  # GET /game_statistics
  def index
    @tasks = Task.all
    render json: @tasks

  # GET /game_statistics/1
  def show
    render json: @task
  end

  # POST /game_statistics
  def create
    @task = Task.new(tasks_params)

    if @task.save
      render json: @task, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /game_statistics/1
  def update
    if @task.update(tasks_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /game_statistics/1
  def destroy
    @task.destroy
  end

  def mark_as_completed; end

  def start_task; end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_statistic
      @task = Task.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def tasks_params
      params.permit(:title, :stage_id, :user_id, :status )
    end
end
