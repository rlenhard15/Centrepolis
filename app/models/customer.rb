class Customer < User
  has_many :sub_category_progresses, dependent: :destroy
  belongs_to :admin, foreign_key: "created_by"
  has_many :assessment_progresses, dependent: :destroy

  after_create :send_email

  def assessments_risk_list
    Assessment.with_assessment_progresses(id).map do |assessment|
      {
        assessment: assessment.name,
        risk_value: assessment.risk_value
      }
    end
  end

  private

  def send_email
    # TODO: We should pass simple data types instead of object
    UsersMailer.with(
      customer: self
    ).email_for_restore_password.deliver_later
  end
end
