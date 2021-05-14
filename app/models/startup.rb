class Startup < ApplicationRecord
  has_many :startup_admins, foreign_key: "startup_id"
  has_many :members, foreign_key: "startup_id"
  has_many :admins_startups, dependent: :destroy
  has_many :admins, through: :admins_startups
  belongs_to :accelerator
  has_many :sub_category_progresses, dependent: :destroy
  has_many :assessment_progresses, dependent: :destroy

  paginates_per 10

  accepts_nested_attributes_for :admins_startups

  def admins_for_startup
    admins.where("users.type = ?", "Admin")
  end

end
