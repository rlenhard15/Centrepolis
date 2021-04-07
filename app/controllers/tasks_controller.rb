class TasksController < ApplicationController
  before_action :set_task_for_show, only: :show
  before_action :set_customer, only: [:index]
  before_action :set_task, only: [:update, :mark_task_as_completed, :destroy]

  api :GET, 'api/tasks', "Tasks list for customer"

  param :customer_id, Integer, desc: "id of customer, required if current_user is admin"

  description <<-DESC
  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
  [
    {
      "id": 63,
      "title": "Task",
      "priority": "high",
      "due_date": "2020-03-02T16:30:43.044Z",
      "master_assessment": "Assessment",
      "category": "Category",
      "sub_category": "SubCategory",
      "stage_title": "Stage"
    },
    ...
  ]
  DESC
  def index
    @tasks = policy_scope(Task).where(user_id: @customer.id)

    render json: @tasks.with_all_required_info_for_tasks
  end

  api :GET, 'api/tasks/:id', "Request for a certain task"
  param :id, Integer, desc: "id of task",  required: true

  description <<-DESC

  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
  {
    "id": 104,
    "title": "Task",
    "priority": "medium",
    "due_date": "2020-04-16T00:00:00.000Z",
    "master_assessment": "Assessment",
    "category": "Category",
    "sub_category": "SubCategory",
    "stage_title": "Stage"
  }

  DESC
  def show
    render json: @task
  end

  api :POST, 'api/tasks', "Create new task and assign its to the specific users of the startup"

  param :task, Hash, required: true do
    param :stage_id, Integer, desc: "id of stage", required: true
    param :title, String, desc: 'Name of task', required: true
    param :priority, String, desc: 'Task execution priority', required: true
    param :due_date, DateTime, desc: 'Deadline date', required: true
    param :task_users_attributes, Array, required: true do
      param :user_id, Integer, desc: 'Id of users who have access to the task', required: true
    end
  end

  description <<-DESC

  === Request headers
    Only StartupAdmin can perform this action
      Authentication - string - required
        Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
      Accelerator-Id - integer - required
        Example of Accelerator-Id header : 1

  === Success response body
  {
    "id": 8,
    "title": "New task",
    "stage_id": 4,
    "created_at": "2021-04-07T10:05:54.080Z",
    "updated_at": "2021-04-07T10:05:54.080Z",
    "status": "started",
    "priority": "low",
    "due_date": "2021-09-09T00:00:00.000Z",
    "users": [
      {
        "id": 5,
        "email": "example_member@gmail.com",
        "created_at": "2021-04-06T10:48:34.453Z",
        "updated_at": "2021-04-06T10:48:45.909Z",
        "first_name": "Emily",
        "last_name": "Smith",
        "startup_id": 1,
        "accelerator_id": 1
      },
      ...
    ]
  }

  DESC

  def create
    authorize current_user, policy_class: TaskPolicy

    @task = Task.new(task_members_params)
    if @task.save
      render json: @task.as_json(include: :users), status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  api :PUT, 'api/tasks/:id', "Update info of a certain task"
  param :id, Integer, desc: "id of task",  required: true

  param :task, Hash, required: true do
    param :stage_id, Integer, desc: "id of stage",  required: true
    param :title, String, desc: 'Name of ta:show, sk', required: true
    param :priority, String, desc: 'Task execution priority', required: true
    param :due_date, DateTime, desc: 'Deadline date', required: true
    param :customer_id, Integer, desc: 'Customer who is owner of task', required: true
  end

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

    def task_members_params
      user_ids_for_task = tasks_params[:task_users_attributes].map { |user| user[:user_id] }
      raise Pundit::NotAuthorizedError unless @members = policy_scope(User).where(id: user_ids_for_task)
      validated_users_ids_hash = []
      @members.each do |member|
        validated_users_ids_hash.push({user_id: member.id})
      end
      tasks_params_hash = tasks_params.to_h
      tasks_params_hash[:task_users_attributes] = validated_users_ids_hash

      tasks_params_hash
    end

    def set_task
      @task = Task.find_by_id(params[:id])
      authorize @task
    end

    def set_task_for_show
      raise Pundit::NotAuthorizedError unless @task = policy_scope(Task).with_all_required_info_for_tasks.where(id: params[:id]).first
    end

    # Only allow a trusted parameter "white list" through.
    def tasks_params
      params.require(:task).permit(:title, :stage_id, :priority, :due_date, task_users_attributes: [ :user_id ])
    end
end
