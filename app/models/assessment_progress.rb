class AssessmentProgress < ApplicationRecord
  belongs_to :assessment
  belongs_to :customer

  scope :assessment_risk_for_customers, -> {
    joins("LEFT JOIN assessments ON assessments.id = assessment_progresses.assessment_id").
    select("assessments.name AS assessment_name, assessment_progresses.risk_value AS risk_value")
  }
end
