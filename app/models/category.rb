class Category < ApplicationRecord
  belongs_to :assessment
  has_many :sub_categories, dependent: :destroy

  def sub_categories_with_stages
    sub_categories
  end

  scope :current_assessment, ->(assessment_id) {
    where(assessment_id: assessment_id)
  }

  def sub_categories_status(user_id)
    sub_categories.map do |sub_category|
      sub_category.sub_category_progresses.where("sub_category_progresses.customer_id = ?", user_id).map do |progress|
        {
          sub_category: sub_category,
          stages: sub_category.stages,
          current_stage_id: progress.current_stage_id
        }
      end.inject
    end
  end

end
