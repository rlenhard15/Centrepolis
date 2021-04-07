class UsersMailer < ApplicationMailer
  before_action do
    @member = params[:member]
  end

  default from: -> { ENV['SENDER_EMAIL'] }

  def email_for_restore_password
    @reset_token = @member.send(:set_reset_password_token)
    mail(to: @member.email, subject: "You have been invited to RAMP Client Business Planning Support")
  end

end
