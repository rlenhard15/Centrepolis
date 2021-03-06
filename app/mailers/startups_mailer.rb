class StartupsMailer < ApplicationMailer
  before_action do
    if params[:admin_ids]
      @admins = Admin.where(id: params[:admin_ids]).with_allowed_email_notifications
      @super_admin = SuperAdmin.find_by_id(params[:super_admin_id]) if params[:super_admin_id]
    elsif params[:current_user_id]
      @super_admins = SuperAdmin.where(id: params[:super_admin_ids]).with_allowed_email_notifications
      @current_user = User.find_by_id(params[:current_user_id])
    end

    @startup = Startup.find_by_id(params[:startup_id])
  end

  default from: -> { ENV['SENDER_EMAIL'] }

  def email_for_assigned_admins
    if !@admins.empty? && !@super_admin
      admins_emails = @admins.map(&:email)
      mail(to: admins_emails, subject: "You have been assigned to startup on RAMP Client Business Planning Support")
    elsif @super_admin && @super_admin.email_notification
      mail(to: @super_admin.email, subject: "You assigned admin(s) to a startup on RAMP Client Business Planning Support")
    end
  end

  def email_startup_created
    if @current_user && @current_user.email_notification
      mail(to: @current_user.email, subject: "You created new startup on RAMP Client Business Planning Support")
    end
  end

  def email_startup_created_to_super_admins
    if !@super_admins.empty?
      super_admins_emails = @super_admins.map(&:email)
      mail(to: super_admins_emails, subject: "New startup has been created on RAMP Client Business Planning Support")
    end
  end
end
