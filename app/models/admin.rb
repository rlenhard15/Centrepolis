class Admin < User
  has_many :admins_startups, foreign_key: "admin_id", dependent: :destroy
  has_many :startups, through: :admins_startups
  belongs_to :accelerator, foreign_key: "accelerator_id"

  after_create :send_email
  after_destroy :send_email_about_delete_account

  private

    def send_email_about_delete_account
      UsersMailer.with(
        deleted_admin: self
      ).email_after_delete_admin.deliver_later
    end
end
