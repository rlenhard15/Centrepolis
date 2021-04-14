class Admin < User
  has_many :admins_startups, foreign_key: "admin_id", dependent: :destroy
  has_many :startups, through: :admins_startups
end
