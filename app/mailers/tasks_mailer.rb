class TasksMailer < ApplicationMailer
  before_action do
    @startup_admins = StartupAdmin.where(id: params[:startup_admins_ids])
    @member = Member.find_by_id(params[:member_id])
    @task = Task.find_by_id(params[:task_id])
  end

  default from: -> { ENV['SENDER_EMAIL'] }

  def email_task_completed
    if @startup_admins && @member && @task
      startup_admins_emails = @startup_admins.map(&:email)
      mail(to: startup_admins_emails, subject: "User of your startup completed task on RAMP Client Business Planning support tool")
    end
  end
end
