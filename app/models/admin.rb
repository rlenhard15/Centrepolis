class Admin < User
  has_many :admins_startups, foreign_key: "admin_id", dependent: :destroy
  has_many :startups, through: :admins_startups
  belongs_to :accelerator, foreign_key: "accelerator_id"

  after_create :send_email
end
