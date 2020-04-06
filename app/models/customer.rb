class Customer < User
  has_many :sub_category_progresses, dependent: :destroy
  belongs_to :admin, foreign_key: "created_by"
  has_many :assessment_progresses, dependent: :destroy

  after_create :send_email

  def assessments_risk_list
    Assessment.with_assessment_progresses(self.id).map do |customer|
      {
        assessment: customer.name,
        risk_value: customer.risk_value
      }
    end
  end

  private

  def send_email
    UsersMailer.with(
      customer: self
    ).email_for_restore_password.deliver_later
  end
end
