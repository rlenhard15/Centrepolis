class Member < User
  belongs_to :startup, foreign_key: "startup_id"
  belongs_to :accelerator, foreign_key: "accelerator_id"

  paginates_per 10

  after_create :send_email
  after_destroy :send_email_about_delete_account
end
