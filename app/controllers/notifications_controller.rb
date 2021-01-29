class NotificationsController < ApplicationController
  before_action :set_notification, only: :mark_as_readed

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

    render json: policy_scope(Notification).with_task_and_admin_info
  end

  api :PUT, '/api/notifications/mark_as_readed_all', "Update all notifications of customer to true"

  description <<-DESC

  === Request headers
  Only customer can perform this action
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
  {
    "message": "Successfully update read status to true for all customer notifications"
  }

  DESC
  def mark_as_readed_all
    authorize current_user, policy_class: NotificationPolicy

    if policy_scope(Notification).update_all(read: true)
      render json: { message: "Successfully update read status to true for all customer notifications" }
    else
      render json: {error: "Notifications were not update"}
    end
  end

  api :PUT, 'api/notifications/:id/mark_as_readed', "Update read status of notification to true"
  param :id, Integer, desc: "id of notification",  required: true

  description <<-DESC

  === Request headers
  Only customer can perform this action
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

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

  def set_notification
    @notification = Notification.find_by_id(params[:id])
    authorize @notification
  end
end