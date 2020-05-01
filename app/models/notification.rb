class Notification < ApplicationRecord
  belongs_to :task
  belongs_to :customer

  scope :with_task_and_admin_info, ->{
    joins(task: :admin).select("tasks.title AS task_title,
      CONCAT(users.first_name, ' ', users.last_name) AS admin_name,
      notifications.id, notifications.created_at, notifications.read"
    )
  }
end
