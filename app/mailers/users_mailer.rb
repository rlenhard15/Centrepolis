class UsersMailer < ApplicationMailer
  before_action do
    if params[:deleted_user] && !params[:current_user_id]
      @deleted_user = params[:deleted_user]
      @current_user = nil
    elsif params[:current_user_id] && params[:deleted_user]
      @deleted_user = params[:deleted_user]
      @current_user = User.find_by_id(params[:current_user_id])
    elsif params[:user_id] && (!params[:current_user_id] && !params[:deleted_user])
      @user = User.find_by_id(params[:user_id])
      @deleted_user = nil
      @current_user = nil
    end
  end

  default from: -> { ENV['SENDER_EMAIL'] }

  def email_for_restore_password
    puts [@user].inspect
    if @user
      @reset_token = @user.send(:set_reset_password_token)
      mail(to: @user.email, subject: "You have been invited to RAMP Client Business Planning Support")
    end
  end

  def email_after_delete_user
    if @deleted_user && !@current_user
      mail(to: @deleted_user.email, subject: "Your account has been deleted on RAMP Client Business Planning Support")
    elsif @deleted_user && @current_user
      mail(to: @current_user.email, subject: "You deleted user account on RAMP Client Business Planning Support")
    end
  end
end
