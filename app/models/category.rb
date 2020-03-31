class Category < ApplicationRecord
  belongs_to :assessment
  has_many :sub_categories, dependent: :destroy

  scope :for_assessment, ->(assessment_id) { where(assessment_id: assessment_id) }

  def sub_categories_with_statuses(user_id)
    sub_categories.
    includes(:stages).
    joins(Arel.sql("LEFT JOIN sub_category_progresses ON (sub_category_progresses.sub_category_id = sub_categories.id AND sub_category_progresses.customer_id = #{user_id})")).
    select("sub_categories.title, sub_categories.id, sub_category_progresses.current_stage_id AS current_stage_id").
    map do |sc|
      {
        title_category: self.title,
        title_sub_category: sc.title,
        current_stage_id: sc.current_stage_id,
        stages: sc.stages
      }
    end
  end
end
