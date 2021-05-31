class TasksController < ApplicationController
  before_action :set_task_for_show, only: :show
  before_action :set_startup, only: [:index]
  before_action :set_task, only: [:update, :mark_task_as_completed, :destroy]

  api :GET, 'api/tasks', "Tasks list for startup"

  param :startup_id, Integer, desc: "id of a startup, required if current_user is SuperAdmin or Admin"
  param :page, Integer, desc: "Page for tasks iteration (10 items per page)"

  description <<-DESC
  === Request headers
    SuperAdmin or Admin or StartupAdmin or Member can perform this action
      SuperAdmin   - all tasks of any accelerator;
      Admin        - all tasks of the startups that were created by the admin;
      StartupAdmin - all tasks of the startup of StartupAdmin;
      Member       - all tasks that assigned to the member
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
    Accelerator-Id - integer - required
      Example of Accelerator-Id header : 1

  === Success response body
  {
    "current_page": 1,
    "total_pages": 3,
    "tasks": [
      {
        "id": 2,
        "title": "Test task 2",
        "status": "completed",
        "priority": "high",
        "due_date": "2020-03-12T00:00:00.000Z",
        "master_assessment": "CRL (Commercial Readiness Level)",
        "category": "IP Risk",
        "sub_category": "Development Status",
        "stage_title": "Basic tests showing potential",
        "members_for_task": [
          {
            "id": 3,
            "email": "member@gmail.com",
            "created_at": "2021-04-09T18:51:32.967Z",
            "updated_at": "2021-04-09T19:04:59.508Z",
            "first_name": "Eva",
            "last_name": "Evans",
            "accelerator_id": 1,
            "startup_id": 1
          },
          ...
        ]
      },
      ...
    ]
  }

  DESC

  def index
    @tasks = policy_scope(Task).tasks_for_startup(@startup.id).distinct.page(page_params)

    render json: {
      current_page: @tasks.current_page,
      total_pages: @tasks.total_pages,
      tasks: @tasks.with_all_required_info_for_tasks.as_json(methods: :members_for_task)
    }
  end

  api :GET, 'api/tasks/:id', "Request for a certain task"
  param :id, Integer, desc: "id of task",  required: true

  description <<-DESC

  === Request headers
    SuperAdmin or Admin or StartupAdmin (who assigned to the task) or Member can perform this action
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
    Accelerator-Id - integer - required
      Example of Accelerator-Id header : 1

  === Success response body
  {
    "id": 1,
    "title": "New task",
    "status": "started",
    "priority": "high",
    "due_date": "2020-03-12T00:00:00.000Z",
    "master_assessment": "CRL (Commercial Readiness Level)",
    "category": "IP Risk",
    "sub_category": "Development Status",
    "stage_title": "Basic tests showing potential",
    "members_for_task": [
      {
        "id": 3,
        "email": "member@gmail.com",
        "created_at": "2021-04-09T18:51:32.967Z",
        "updated_at": "2021-04-09T19:04:59.508Z",
        "first_name": "Eva",
        "last_name": "Evans",
        "accelerator_id": 1,
        "startup_id": 1
      },
      ...
    ]
  }

  DESC
  def show
    render json: @task.as_json(methods: :members_for_task)
  end

  api :POST, 'api/tasks', "Create new task and assign its to the specific users of the startup"

  param :task, Hash, required: true do
    param :stage_id, Integer, desc: "id of stage", required: true
    param :title, String, desc: 'Name of task', required: true
    param :priority, String, desc: 'Task execution priority (can be low, medium or high)', required: true
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

    @task = Task.new(task_members_params_create)
    if @task.save
      render json: @task.as_json(methods: :members_for_task), status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  api :PUT, 'api/tasks/:id', "Update info of a certain task and assign users to the task"
  param :id, Integer, desc: "id of task",  required: true

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
    Only StartupAdmin who assign to the task can perform this action
      Authentication - string - required
        Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
      Accelerator-Id - integer - required
        Example of Accelerator-Id header : 1

  === Success response body
  {
    "id": 1,
    "title": "New task",
    "stage_id": 2,
    "created_at": "2021-04-12T08:43:09.122Z",
    "updated_at": "2021-04-12T14:46:31.944Z",
    "status": "started",
    "priority": "high",
    "due_date": "2020-03-12T00:00:00.000Z",
    "members_for_task": [
      {
        "id": 3,
        "email": "member@gmail.com",
        "created_at": "2021-04-09T18:51:32.967Z",
        "updated_at": "2021-04-09T19:04:59.508Z",
        "first_name": "Eva",
        "last_name": "Evans",
        "accelerator_id": 1,
        "startup_id": 1
      },
      ...
    ]
  }

  DESC
  def update
    if @task.update(task_members_params)
      render json: @task.as_json(methods: :members_for_task)
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  api :PUT, 'api/tasks/:id/mark_task_as_completed', "Update task status to completed"
  param :id, Integer, desc: "id of task",  required: true

  description <<-DESC

  === Request headers
    SuperAdmin or Admin or StartupAdmin(who assigned to the task) or Member can perform this action
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
    Accelerator-Id - integer - required
      Example of Accelerator-Id header : 1

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
    Only StartupAdmin who assign to the task can perform this action
      Authentication - string - required
        Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
      Accelerator-Id - integer - required
        Example of Accelerator-Id header : 1

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

    def page_params
      params[:page] || 1
    end

    def set_startup
      raise Pundit::NotAuthorizedError unless for_startup
    end

    def for_startup
      @startup = (current_user.member? || current_user.startup_admin?) ? current_user.startup : policy_scope(Startup).where(id: params[:startup_id], accelerator_id: user_accelerator_id).first
    end

    def task_members_params
      if tasks_params[:task_users_attributes]
        user_ids_for_task = tasks_params[:task_users_attributes].map { |user| user[:user_id] }
        raise Pundit::NotAuthorizedError unless @users = policy_scope(User).where(id: user_ids_for_task)
        validated_users_ids_hash = []

        @users.each do |user|
          if @task
            validated_users_ids_hash.push({user_id: user.id}) if !user.task_ids.include?(@task.id)
          else
            validated_users_ids_hash.push({user_id: user.id})
          end
        end

        tasks_params_hash = tasks_params.to_h
        tasks_params_hash[:task_users_attributes] = validated_users_ids_hash
        return tasks_params_hash
      end

      return tasks_params
    end

    def task_members_params_create
      tasks_params_for_create = task_members_params
      tasks_params_for_create[:task_users_attributes].push({user_id: current_user.id})

      tasks_params_for_create
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
