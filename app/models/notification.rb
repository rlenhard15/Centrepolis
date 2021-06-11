class Notification < ApplicationRecord
  belongs_to :task
  belongs_to :user

  paginates_per 10

  scope :with_task_info, ->{
    joins(task: :users).select("tasks.title AS task_title, notifications.id, notifications.created_at, notifications.read")
  }
end
