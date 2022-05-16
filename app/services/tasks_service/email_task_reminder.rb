class TasksService::EmailTaskReminder < ApplicationService
  attr_accessor :task, :current_user, :task_params

  def initialize(task, current_user)
    @task = task
    @task_params = task_params
    @current_user = current_user
  end

  def call
    send_email if !current_user.member? && !users_for_task.empty?
  end

  private

  def send_email
    TasksMailer.with(
      users_ids: users_for_task,
      task_id: task.id
    ).email_task_reminder.deliver_now
  end

  def users_for_task
    @users_ids_for_startup ||= task.task_users.map { |user| user[:user_id] if user[:user_id] != current_user.id }
    @users_ids_for_startup.compact
  end
end
