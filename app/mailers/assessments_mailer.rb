class AssessmentsMailer < ApplicationMailer
  before_action do
    @sub_category_progress = SubCategoryProgress.find_by_id(params[:sub_category_progress_id])
    @assessment_progress = AssessmentProgress.find_by_id(params[:assessment_progress_id])
    @startup = Startup.find_by_id(@assessment_progress.startup_id)
    @current_user = User.find_by_id(params[:current_user_id])
    @current_stage = Stage.find_by_id(@sub_category_progress&.current_stage_id)
  end

  default from: -> { ENV['SENDER_EMAIL'] }

  def email_progress_updated_to_admins
    @super_admins = SuperAdmin.not_current_user(@current_user.id).with_allowed_email_notifications
    @admins = Admin.joins(:startups).where("startups.id = ?", @startup.id).not_current_user(@current_user.id).with_allowed_email_notifications

    if !@super_admins.empty? || !@admins.empty?
      if @sub_category_progress && @assessment_progress && @startup
        super_admins_emails = users_emails(@super_admins)
        admins_emails = users_emails(@admins)
        users_emails = super_admins_emails + admins_emails

        mail(to: users_emails, subject: "Stage progress of a startup has been updated on RAMP Client Business Planning Support")
      end
    end
  end

  def email_progress_updated_to_startup_users
    @startup_users = User.join(:users_startup).where('users_startups.startup_id': @startup.id).not_current_user(@current_user.id).with_allowed_email_notifications

    if !@startup_users.empty?
      if @sub_category_progress && @assessment_progress && @startup
        startup_users_emails = users_emails(@startup_users)

        mail(to: startup_users_emails, subject: "The stage progress of your startup has been updated on RAMP Client Business Planning Support")
      end
    end
  end

  def email_progress_updated_to_current_user
    if @sub_category_progress && @assessment_progress && @startup && @current_user.email_notification
      mail(to: @current_user.email, subject: "You updated the stage progress of your startup on RAMP Client Business Planning Support")
    end
  end

  def users_emails users
    users.map(&:email)
  end

end
