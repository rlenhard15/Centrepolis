class StartupsMailer < ApplicationMailer
  before_action do
    @admins = Admin.where(id: params[:admin_ids])
    @startup = Startup.find_by_id(params[:startup_id])
    @super_admin = SuperAdmin.find_by_id(params[:super_admin_id]) if params[:super_admin_id]
  end

  default from: -> { ENV['SENDER_EMAIL'] }

  def email_for_assigned_admins
    if @admins && !@super_admin
      admins_emails = @admins.map(&:email)
      mail(to: admins_emails, subject: "You have been assigned to startup on RAMP Client Business Planning Support")
    elsif @admins && @super_admin
      mail(to: @super_admin.email, subject: "You assigned admin(s) to a startup on RAMP Client Business Planning Support")
    end
  end

end
