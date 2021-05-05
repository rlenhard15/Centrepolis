class Member < User
  has_many :sub_category_progresses, dependent: :destroy
  belongs_to :startup
  has_many :assessment_progresses, dependent: :destroy
  has_many :notifications

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
