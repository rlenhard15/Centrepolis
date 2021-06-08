class TasksMailer < ApplicationMailer
  before_action do
    if params[:startup_admins_ids]
      @startup_admins = StartupAdmin.where(id: params[:startup_admins_ids])&.with_allowed_email_notifications
      @member = Member.find_by_id(params[:member_id])
      @task = Task.find_by_id(params[:task_id])
    elsif params[:users_ids]
      @users = User.where(id: params[:users_ids])&.with_allowed_email_notifications
      @startup = Startup.find_by_id(@users&.first&.startup&.id)
      @task = Task.find_by_id(params[:task_id])
    end
  end

  default from: -> { ENV['SENDER_EMAIL'] }

  def email_task_completed
    if !@startup_admins.empty? && @member && @task
      startup_admins_emails = @startup_admins.map(&:email)
      mail(to: startup_admins_emails, subject: "User of your startup completed task on RAMP Client Business Planning support tool")
    end
  end

  def email_users_assigned
    if !@users.empty? && @task
      users_emails = @users.map(&:email)
      mail(to: users_emails, subject: "You have been assigned to a task on RAMP Client Business Planning support tool")
    end
  end
end
