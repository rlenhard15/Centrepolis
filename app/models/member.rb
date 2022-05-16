class Member < User
  belongs_to :accelerator, foreign_key: "accelerator_id"
  has_many :users_startups, foreign_key: 'user_id'

  paginates_per 10

  after_create :send_email
  after_destroy :send_email_about_delete_account
end
