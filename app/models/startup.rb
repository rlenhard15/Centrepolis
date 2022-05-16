class Startup < ApplicationRecord
  has_many :users_startup, foreign_key: 'startups_id'
  has_many :members, :through => :users_startup, source: :user
  has_many :admins, -> {where('users.type' => 'Admin')}, through: :users_startup, source: :user
  belongs_to :accelerator
  has_many :sub_category_progresses, dependent: :destroy
  has_many :assessment_progresses, dependent: :destroy
  has_many :team_leads, -> {where('users_startups.is_team_lead' => true)}, through: :users_startup, source: :user

  paginates_per 10

  def admins_for_startup
    admins.where("users.type = ?", "Admin")
  end

  scope :for_accelerator, ->(accelerator_id) { where(accelerator_id: accelerator_id)}
  scope :with_user, ->(user_id) { joins(:users_startup).where(users_startups: {:user_id => user_id} )}

  def assessments_risk_list
    Assessment.with_assessment_progresses(id).map do |assessment|
      {
        assessment: assessment.name,
        risk_value: assessment.risk_value
      }
    end
  end
end
