class NotificationsController < ApplicationController
  before_action :set_notification, only: :mark_as_readed

  api :GET, 'api/notifications', "List of notifications for current_user"
  param :page, Integer, desc: "Page for notifications iteration (10 items per page)"

  description <<-DESC

  === Request headers
  SuperAdmin, Admin, StartupAdmin or Member can perform this action
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
    Accelerator-Id - integer - required
      Example of Accelerator-Id header : 1

  === Success response body
  {
    "current_page": 1,
    "total_pages": 2,
    "notifications": [
      {
        "id": 1,
        "task_id": 2,
        "user_id": 3,
        "read": false,
        "created_at": "2021-06-09T18:21:04.314Z",
        "updated_at": "2021-06-09T18:21:04.314Z",
        "task": {
          "id": 2,
          "title": "Test task 2",
          "stage_id": 2,
          "created_at": "2021-04-12T08:44:20.334Z",
          "updated_at": "2021-04-12T15:37:07.813Z",
          "status": "completed",
          "priority": "high",
          "due_date": "2020-03-12T00:00:00.000Z",
          "users": [
            {
              "id": 3,
              "email": "customer@gmail.com",
              "created_at": "2021-04-09T18:51:32.967Z",
              "updated_at": "2021-06-10T13:11:51.485Z",
              "first_name": "Nelli",
              "last_name": "Bilokon",
              "accelerator_id": 1,
              "startup_id": 1,
              "phone_number": "123456789",
              "email_notification": true,
              "last_visit": "2021-06-10T13:11:34.623Z",
              "user_type": "Member"
            },
            ...
          ]
        }
      },
      ...
    ]
  }
  DESC

  def index
    authorize current_user, policy_class: NotificationPolicy

    @notifications = policy_scope(Notification).page(page_params)

    render json: {
      current_page: @notifications.current_page,
      total_pages: @notifications.total_pages,
      notifications: @notifications.as_json(include: {task: {include: {users: { methods: [:last_visit, :user_type]}}}})
    }
  end

  api :PUT, '/api/notifications/mark_as_readed_all', "Update all notifications of user to true"

  description <<-DESC

  === Request headers
  SuperAdmin, Admin, StartupAdmin or Member can perform this action
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
    Accelerator-Id - integer - required
      Example of Accelerator-Id header : 1

  === Success response body
  {
    "message": "Successfully update read status to true for all user notifications"
  }

  DESC
  def mark_as_readed_all
    authorize current_user, policy_class: NotificationPolicy

    if policy_scope(Notification).update_all(read: true)
      render json: { message: "Successfully update read status to true for all user notifications" }
    else
      render json: {error: "Notifications were not updated"}
    end
  end

  api :PUT, 'api/notifications/:id/mark_as_readed', "Update read status of notification to true"
  param :id, Integer, desc: "id of notification",  required: true

  description <<-DESC

  === Request headers
  SuperAdmin, Admin, StartupAdmin or Member can perform this action
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
    Accelerator-Id - integer - required
      Example of Accelerator-Id header : 1

  === Success response body
  {
    "read_status": "true"
  }

  DESC

  def mark_as_readed
    if @notification.update(read: true)
      render json: { read_status: @notification.read }
    else
      render json: @notification.error, status: :unprocessable_entity
    end
  end

  private

  def page_params
    params[:page] || 1
  end

  def set_notification
    @notification = Notification.find_by_id(params[:id])
    authorize @notification
  end
end
