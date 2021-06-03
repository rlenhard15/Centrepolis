class TasksService::EmailTaskCompleted < ApplicationService
  attr_accessor :task, :current_user, :startup_admins_ids

  def initialize(task, current_user)
    @task = task
    @current_user = current_user
  end

  def call
    send_email if current_user.member? && startup_admins_for_task && task_completed
  end

  private

  def send_email
    TasksMailer.with(
      startup_admins_ids: startup_admins_ids,
      member_id: current_user.id,
      task_id: task.id
    ).email_task_completed.deliver_later
  end

  def startup_admins_for_task
    @startup_admins_ids ||= task.users&.where(type: 'StartupAdmin').map(&:id)
  end

  def task_completed
    task.status == 'completed'
  end

end
