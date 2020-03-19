class UsersMailer < ApplicationMailer
  before_action do
    @customer = params[:customer]
  end

  default from: -> { ENV['SENDER_EMAIL'] }

  def email_for_restore_password
    @token = @customer.send(:reset_password)
    mail(to: @customer.email, subject: "You've been invited to Trello forms")
  end

end
