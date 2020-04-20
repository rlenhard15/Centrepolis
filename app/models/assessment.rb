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
    result_hash = sub_categories.with_stages_progresses(customer_id).
    joins("LEFT JOIN stages ON (stages.id = sub_category_progresses.current_stage_id)").
    select("sub_categories.id, stages.position AS position").
    inject({percentage: 0, total_number_of_sc: 0}) do |result, current_sub|
      result[:percentage] += ( (current_sub.position || 0) / current_sub.stages.length.to_f )
      result[:total_number_of_sc] += 1
      result
    end

    (result_hash[:percentage] / result_hash[:total_number_of_sc]) * 100
  end
end
