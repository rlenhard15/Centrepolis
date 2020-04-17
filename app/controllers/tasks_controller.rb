class TasksController < ApplicationController
  before_action :set_stage
  before_action :set_customer, only: :create
  before_action :set_task, only: [:show, :update, :mark_task_as_completed, :destroy]

  api :GET, 'api/assessments/:assessment_id/categories/:category_id/sub_categories/:sub_category_id/stages/:stage_id/tasks', "Tasks list of a certain stage"
  param :assessment_id, Integer, desc: "id of assessment",  required: true
  param :category_id, Integer, desc: "id of category",  required: true
  param :sub_category_id, Integer, desc: "id of sub_category",  required: true
  param :stage_id, Integer, desc: "id of stage",  required: true

  param :customer_id, Integer, desc: "id of customer, required if current_user is admin", required: true

  description <<-DESC
  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
  [
    {
      "title": "Task",
      "priority": "low",
      "due_date": "2020-04-01T17:29:50.528Z",
      "desc_for_tasks": {
        "assessment": {
          "id": 4,
          "name": "Assessment",
          "created_at": "2020-04-01T17:29:50.528Z",
          "updated_at": "2020-04-01T17:29:50.528Z"
        },
        "stage": {
          "id": 20,
          "title": "Stage",
          "created_at": "2020-04-01T17:29:50.927Z",
          "updated_at": "2020-04-01T17:29:50.927Z",
          "position": 5,
          "sub_category_id": 6
        },
        "risk_category": 31.666666666666664,
        "risk_sub_category": 66.66666666666666
      }
    },
    ...
  ]
  DESC
  def index
    @tasks = policy_scope(Task)
    render json: @tasks.as_json(methods: :desc_for_tasks, only: [:title, :due_date, :priority])
  end

  api :GET, 'api/assessments/:assessment_id/categories/:category_id/sub_categories/:sub_category_id/stages/:stage_id/tasks/:id', "Request for a certain task"
  param :assessment_id, Integer, desc: "id of assessment",  required: true
  param :category_id, Integer, desc: "id of category",  required: true
  param :sub_category_id, Integer, desc: "id of sub_category",  required: true
  param :stage_id, Integer, desc: "id of stage",  required: true
  param :id, Integer, desc: "id of task",  required: true

  param :customer_id, Integer, desc: "id of customer, required if current_user is admin", required: true

  description <<-DESC

  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
  {
    "title": "Task",
    "priority": "low",
    "due_date": "2020-04-01T17:29:50.528Z",
    "desc_for_tasks": {
      "assessment": {
        "id": 4,
        "name": "Assessment",
        "created_at": "2020-04-01T17:29:50.528Z",
        "updated_at": "2020-04-01T17:29:50.528Z"
      },
      "stage": {
        "id": 20,
        "title": "Stage",
        "created_at": "2020-04-01T17:29:50.927Z",
        "updated_at": "2020-04-01T17:29:50.927Z",
        "position": 5,
        "sub_category_id": 6
      },
      "risk_category": 31.666666666666664,
      "risk_sub_category": 66.66666666666666
    }
  }

  DESC
  def show
    render json: @task.as_json(methods: :desc_for_tasks, only: [:title, :due_date, :priority])
  end

  api :POST, 'api/assessments/:assessment_id/categories/:category_id/sub_categories/:sub_category_id/stages/:stage_id/tasks', "Create new task for user"
  param :assessment_id, Integer, desc: "id of assessment",  required: true
  param :category_id, Integer, desc: "id of category",  required: true
  param :sub_category_id, Integer, desc: "id of sub_category",  required: true
  param :stage_id, Integer, desc: "id of stage",  required: true

  param :title, String, desc: 'Name of task', required: true
  param :customer_id, Integer, desc: 'customer who belongs task', required: true

  description <<-DESC

  === Request headers
    Only admin can perform this action
      Authentication - string - required
        Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
  {
     "id": 37,
     "title": "Task",
     "stage_id": 8,
     "created_at": "2020-03-02T16:30:43.044Z",
     "updated_at": "2020-03-02T16:30:43.044Z",
     "created_by": 290,
     "user_id": 48,
     "status": "started"
  }

  DESC

  def create
    @task = @stage.tasks.new(
      tasks_params.merge({
        created_by: current_user.id,
        user_id: @customer.id
      })
    )
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

  description <<-DESC

  === Request headers
    Only admin can perform this action
      Authentication - string - required
        Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
  {
     "id": 37,
     "title": "Task",
     "stage_id": 8,
     "created_at": "2020-03-02T16:30:43.044Z",
     "updated_at": "2020-03-02T16:30:43.044Z",
     "created_by": 290,
     "user_id": 48,
     "status": "started"
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
    Only admin can perform this action
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

    def set_customer
      raise Pundit::NotAuthorizedError unless @customer = policy_scope(Customer).where(id: params[:customer_id]).first
    end

    def set_task
      @task = Task.find_by_id(params[:id])
      authorize @task
    end

    def set_stage
      @stage = Stage.find(params[:stage_id])
    end

    # Only allow a trusted parameter "white list" through.
    def tasks_params
      params.permit(:title)
    end
end
