class Customer < User
  belongs_to :admin, foreign_key: "created_by"

  after_create :send_email

  def send_email
    UsersMailer.with(
      customer: Customer.last
    ).email_for_restore_password.deliver
  end
end
