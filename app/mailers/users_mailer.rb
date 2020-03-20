class UsersMailer < ApplicationMailer
  before_action do
    @customer = params[:customer]
  end

  default from: -> { ENV['SENDER_EMAIL'] }

  def email_for_restore_password
    @reset_token = @customer.send(:set_reset_password_token)
    mail(to: @customer.email, subject: "You have been invited to Trello forms")
  end

end
