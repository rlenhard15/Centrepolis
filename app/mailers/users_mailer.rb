class UsersMailer < ApplicationMailer
  before_action do
    if params[:deleted_admin] && !params[:super_admin_id]
      @deleted_admin = params[:deleted_admin]
      @super_admin = nil
    elsif params[:super_admin_id] && params[:deleted_admin]
      @deleted_admin = params[:deleted_admin]
      @super_admin = SuperAdmin.find_by_id(params[:super_admin_id])
    elsif params[:user_id] && (!params[:super_admin_id] && !params[:deleted_admin])
      @user = User.find_by_id(params[:user_id])
      @deleted_admin = nil
      @super_admin = nil
    end
  end

  default from: -> { ENV['SENDER_EMAIL'] }

  def email_for_restore_password
    if @user
      @reset_token = @user.send(:set_reset_password_token)
      mail(to: @user.email, subject: "You have been invited to RAMP Client Business Planning Support")
    end
  end

  def email_after_delete_admin
    if @deleted_admin && @deleted_admin.admin? && !@super_admin
      mail(to: @deleted_admin.email, subject: "Your account has been deleted on RAMP Client Business Planning Support")
    elsif @deleted_admin && @deleted_admin.admin? && @super_admin
      mail(to: @super_admin.email, subject: "You deleted admin account on RAMP Client Business Planning Support")
    end
  end
end
