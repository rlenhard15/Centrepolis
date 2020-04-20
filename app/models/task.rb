class Task < ApplicationRecord
  belongs_to :stage
  belongs_to :admin, foreign_key: "created_by"
  belongs_to :customer, foreign_key: "user_id"

  enum status: [:started, :completed]
  enum priority: [:low, :medium, :high]

  def desc_for_task
    {
      assessment: stage.sub_category.category.assessment.name,
      stage: stage.title,
      category: stage.sub_category.category.title,
      sub_category: stage.sub_category.title
    }
  end

end
