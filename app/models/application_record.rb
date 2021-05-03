class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private

  def send_email
    UsersMailer.with(
      user_id: self.id
    ).email_for_restore_password.deliver_later
  end
end
