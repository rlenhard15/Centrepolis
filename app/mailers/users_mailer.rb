class UsersMailer < ApplicationMailer
  before_action do
    @user = User.find_by_id(params[:user_id]) if params[:user_id]
    @deleted_admin = params[:deleted_admin] if params[:deleted_admin]
  end

  default from: -> { ENV['SENDER_EMAIL'] }

  def email_for_restore_password
    if @user
      @reset_token = @user.send(:set_reset_password_token)
      mail(to: @user.email, subject: "You have been invited to RAMP Client Business Planning Support")
    end
  end

  def email_after_delete_admin
    if @deleted_admin && @deleted_admin.admin?
      mail(to: @deleted_admin.email, subject: "Your account has been deleted on RAMP Client Business Planning Support")
    end
  end

end
