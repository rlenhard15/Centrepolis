class Category < ApplicationRecord
  belongs_to :assessment
  has_many :sub_categories, dependent: :destroy

  scope :for_assessment, ->(assessment_id) { where(assessment_id: assessment_id) }

  def sub_categories_with_statuses(customer_id)
    sub_categories.with_stages_progresses(customer_id).
    select("sub_categories.title, sub_categories.id, sub_category_progresses.current_stage_id AS current_stage_id").
    map do |sc|
      {
        title_sub_category: sc.title,
        current_stage_id: sc.current_stage_id,
        stages: sc.stages
      }
    end
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
