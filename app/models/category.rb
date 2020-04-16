class Category < ApplicationRecord
  belongs_to :assessment
  has_many :sub_categories, dependent: :destroy

  scope :for_assessment, ->(assessment_id) { where(assessment_id: assessment_id) }

  def risk_category(customer_id)
    result_hash = sub_categories.calculate_risk_value(customer_id)

    (result_hash[:percentage] / result_hash[:total_number_of_sc]) * 100
  end

  def sub_categories_with_statuses(customer_id)
    sub_categories.with_stages_progresses(customer_id).
    select("sub_categories.title, sub_categories.id, sub_category_progresses.current_stage_id AS current_stage_id").
    map do |sc|
      {
        sub_category_id: sc.id,
        sub_category_title: sc.title,
        current_stage_id: sc.current_stage_id,
        stages: sc.stages
      }
    end
  end
end
