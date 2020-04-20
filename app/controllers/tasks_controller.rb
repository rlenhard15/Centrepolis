class TasksController < ApplicationController
  before_action :set_stage, only: :create
  before_action :set_customer, only: [:index, :create]
  before_action :set_task, only: [:show, :update, :mark_task_as_completed, :destroy]

  api :GET, 'api/tasks', "Tasks list for customer"

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
      "due_date": "2020-04-01T17:29:50.927Z",
      "desc_for_task": {
        "master_assessment": "Assessment",
        "stage": "Stage",
        "risk_category": "Category",
        "risk_sub_category": "SubCategory"
      }
    },
    ...
  ]
  DESC
  def index
    @tasks = policy_scope(Task).where(user_id: @customer.id)

    render json: @tasks.as_json(methods: :desc_for_task, only: [:title, :due_date, :priority])
  end

  api :GET, 'api/tasks/:id', "Request for a certain task"
  param :id, Integer, desc: "id of task",  required: true

  description <<-DESC

  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
  {
    "title": "Task",
    "priority": "high",
    "due_date": "2020-04-01T17:29:50.927Z",
    "desc_for_task": {
      "master_assessment": "Assessment",
      "stage": "Stage",
      "risk_category": "Category",
      "risk_sub_category": "SubCategory"
    }
  }

  DESC
  def show
    render json: @task.as_json(methods: :desc_for_task, only: [:title, :due_date, :priority])
  end

  api :POST, 'api/tasks', "Create new task for customer"

  param :stage_id, Integer, desc: "id of stage",  required: true
  param :title, String, desc: 'Name of task', required: true
  param :priority, String, desc: 'Task execution priority', required: true
  param :due_date, DateTime, desc: 'Deadline date', required: true
  param :customer_id, Integer, desc: 'Customer who is owner of task', required: true

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
    authorize current_user, policy_class: TaskPolicy

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

  api :PUT, 'api/tasks/:id', "Update info of a certain task"
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

  api :PUT, 'api/tasks/:id/mark_task_as_completed', "Update task status to completed"
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

  api :DELETE, 'api/tasks/:id', 'Delete task'
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
      raise Pundit::NotAuthorizedError unless @customer = current_user.admin? ? policy_scope(Customer).where(id: params[:customer_id]).first : current_user
    end

    def set_task
      @task = Task.find_by_id(params[:id])
      authorize @task
    end
    
    # Only allow a trusted parameter "white list" through.
    def tasks_params
      params.permit(:title, :stage_id, :priority, :due_date)
    end
end
