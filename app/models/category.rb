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
end
