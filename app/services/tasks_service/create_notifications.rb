class TasksService::CreateNotifications < ApplicationService
  attr_accessor :task, :current_user, :assigned_users

  def initialize(task, current_user, assigned_users_ids)
    @task = task
    @current_user = current_user
    @assigned_users = User.where(id: assigned_users_ids)
  end

  def call

  end

  private

  def create_notifications

  end

end
