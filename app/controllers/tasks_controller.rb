class TasksController < ApplicationController
  before_action :set_stage
  before_action :set_task, only: [:show, :update, :mark_task_as_completed, :destroy]

  api :GET, 'api/assessments/:assessment_id/categories/:category_id/sub_categories/:sub_category_id/stages/:stage_id/tasks', "Tasks list of a certain stage"
  param :assessment_id, Integer, desc: "id of assessment",  required: true
  param :category_id, Integer, desc: "id of category",  required: true
  param :sub_category_id, Integer, desc: "id of sub_category",  required: true
  param :stage_id, Integer, desc: "id of stage",  required: true

  description <<-DESC
  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
  [
    {
      "id": 19,
      "title": "Task",
      "stage_id": 8,
      "created_at": "2020-02-21T15:41:40.718Z",
      "updated_at": "2020-02-21T15:41:40.718Z",
      "user_id": 1,
      "status": "completed"
    },
    ...
  ]
  DESC
  def index
    @tasks = @stage.tasks
    render json: @tasks
  end

  api :GET, 'api/assessments/:assessment_id/categories/:category_id/sub_categories/:sub_category_id/stages/:stage_id/tasks/:id', "Request for a certain task"
  param :assessment_id, Integer, desc: "id of assessment",  required: true
  param :category_id, Integer, desc: "id of category",  required: true
  param :sub_category_id, Integer, desc: "id of sub_category",  required: true
  param :stage_id, Integer, desc: "id of stage",  required: true
  param :id, Integer, desc: "id of task",  required: true

  description <<-DESC

  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
  {
     "id": 37,
     "title": "Task",
     "stage_id": 8,
     "created_at": "2020-03-02T16:30:43.044Z",
     "updated_at": "2020-03-02T16:30:43.044Z",
     "user_id": 48,
     "status": "started"
  }

  DESC
  def show
    render json: @task
  end

  api :POST, 'api/assessments/:assessment_id/categories/:category_id/sub_categories/:sub_category_id/stages/:stage_id/tasks', "Create new task for user"
  param :assessment_id, Integer, desc: "id of assessment",  required: true
  param :category_id, Integer, desc: "id of category",  required: true
  param :sub_category_id, Integer, desc: "id of sub_category",  required: true
  param :stage_id, Integer, desc: "id of stage",  required: true

  param :title, String, desc: 'Name of task', required: true
  param :user_id, Integer, desc: 'user who performs task', required: true
  param :status, Integer, desc: 'value must be only: 0 (means started) or 1 (means completed)', required: true

  description <<-DESC

  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
  {
     "id": 37,
     "title": "Task",
     "stage_id": 8,
     "created_at": "2020-03-02T16:30:43.044Z",
     "updated_at": "2020-03-02T16:30:43.044Z",
     "user_id": 48,
     "status": "started"
  }

  DESC

  def create
    @task = @stage.tasks.new(tasks_params.merge({user_id: current_user.id, status: 'started'}))
    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  api :PUT, 'api/assessments/:assessment_id/categories/:category_id/sub_categories/:sub_category_id/stages/:stage_id/tasks/:id', "Update info of a certain task"
  param :assessment_id, Integer, desc: "id of assessment",  required: true
  param :category_id, Integer, desc: "id of category",  required: true
  param :sub_category_id, Integer, desc: "id of sub_category",  required: true
  param :stage_id, Integer, desc: "id of stage",  required: true
  param :id, Integer, desc: "id of task",  required: true

  param :title, String, desc: 'Name of task', required: true
  param :user_id, Integer, desc: 'user who performs task', required: true
  param :status, Integer, desc: 'value must be only: 0 (means started) or 1 (means completed)', required: true

  description <<-DESC

  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
  {
     "id": 37,
     "title": "Task",
     "stage_id": 8,
     "created_at": "2020-03-02T16:30:43.044Z",
     "updated_at": "2020-03-02T16:30:43.044Z",
     "user_id": 48,
     "status": "completed"
  }

  DESC
  def update
    if @task.update(tasks_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  api :PUT, 'api/assessments/:assessment_id/categories/:category_id/sub_categories/:sub_category_id/stages/:stage_id/tasks/:id/mark_task_as_completed', "Update task status to completed"
  param :assessment_id, Integer, desc: "id of assessment",  required: true
  param :category_id, Integer, desc: "id of category",  required: true
  param :sub_category_id, Integer, desc: "id of sub_category",  required: true
  param :stage_id, Integer, desc: "id of stage",  required: true
  param :id, Integer, desc: "id of task",  required: true

  description <<-DESC

  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
  {
     "new_task_status": "completed"
  }

  DESC

  def mark_task_as_completed
    if @task.update(status: 'completed')
      render json: { new_task_status: @task.status }
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, 'api/assessments/:assessment_id/categories/:category_id/sub_categories/:sub_category_id/stages/:stage_id/tasks/:id', 'Delete task'
  param :assessment_id, Integer, desc: "id of assessment",  required: true
  param :category_id, Integer, desc: "id of category", required: true
  param :sub_category_id, Integer, desc: "id of sub_category", required: true
  param :stage_id, Integer, desc: "id of stage", required: true
  param :id, Integer, desc: "id of task", required: true

  description <<-DESC

  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
  {
     "message": "Successfully destroyed"
  }

  DESC

  def destroy
    if @task.destroy
      render json: {
        message: 'Successfully destroyed'
      }, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  private

    def set_task
      @task = @stage.tasks.find(params[:id])
    end

    def set_stage
      @stage = Stage.find(params[:stage_id])
    end

    # Only allow a trusted parameter "white list" through.
    def tasks_params
      params.permit(:title)
    end
end
