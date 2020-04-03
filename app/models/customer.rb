class Customer < User
  has_many :sub_category_progresses, dependent: :destroy
  belongs_to :admin, foreign_key: "created_by"
  has_many :assessment_progresses, dependent: :destroy

  after_create :send_email

  def assessments_risk_list
    assessment_progresses.assessment_risk_for_customers.map do |customer|
      {
        assessment: customer.assessment_name,
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
