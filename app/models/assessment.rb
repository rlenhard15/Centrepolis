class Assessment < ApplicationRecord
  has_many :categories, dependent: :destroy
  has_many :sub_categories, through: :categories
  has_many :assessment_progresses, dependent: :destroy

  scope :with_assessment_progresses, ->(customer_id) {
    joins(Arel.sql("LEFT JOIN assessment_progresses ON (assessment_progresses.assessment_id = assessments.id AND assessment_progresses.customer_id = #{customer_id})")).
    select("assessments.*, assessment_progresses.risk_value")
  }

  def description_with_child_models
    categories.as_json({include: {sub_categories: {include: :stages }}})
  end

  def assessment_risk(customer_id)
    result_hash = sub_categories.calculate_risk_value(customer_id)

    (result_hash[:percentage] / result_hash[:total_number_of_sc]) * 100
  end
end
