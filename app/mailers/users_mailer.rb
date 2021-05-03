class UsersMailer < ApplicationMailer
  before_action do
    @user = User.find_by_id(params[:user_id])
  end

  default from: -> { ENV['SENDER_EMAIL'] }

  def email_for_restore_password
    if @user
      @reset_token = @user.send(:set_reset_password_token)
      mail(to: @user.email, subject: "You have been invited to RAMP Client Business Planning Support")
    end
  end

end
