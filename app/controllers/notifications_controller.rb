class NotificationsController < ApplicationController

  api :GET, 'api/notifications', "List of notifications for customer"

  description <<-DESC

  === Request headers
  Only customer can perform this action
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
  [
    {
      "id": 2,
      "read": false,
      "created_at": "2020-04-24T13:40:51.364Z",
      "task_title": "Task",
      "admin_name": "Obi Wan"
    },
    ...
  ]
  DESC

  def index
    authorize current_user, policy_class: NotificationPolicy

    @notifications = policy_scope(Notification)

    render json: @notifications.with_task_and_admin_info
  end
end
