class Member < User
  belongs_to :startup, foreign_key: "startup_id"
  has_many :notifications
  belongs_to :accelerator, foreign_key: "accelerator_id"

  after_create :send_email
  after_destroy :send_email_about_delete_account
end
