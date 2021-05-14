class Member < User
  belongs_to :startup, foreign_key: "startup_id"
  has_many :notifications
  belongs_to :accelerator, foreign_key: "accelerator_id"

  after_create :send_email

  def assessments_risk_list
    Assessment.with_assessment_progresses(id).map do |assessment|
      {
        assessment: assessment.name,
        risk_value: assessment.risk_value
      }
    end
  end
end
