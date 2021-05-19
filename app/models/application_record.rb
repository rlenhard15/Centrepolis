class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :for_accelerator, ->(accelerator_id) { where(accelerator_id: accelerator_id) }

  private

  def send_email
    UsersMailer.with(
      user_id: self.id
    ).email_for_restore_password.deliver_later
  end
end
