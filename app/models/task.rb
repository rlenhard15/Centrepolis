class Task < ApplicationRecord
  belongs_to :stage
  belongs_to :admin, foreign_key: "created_by"
  belongs_to :customer, foreign_key: "user_id"

  enum status: [:started, :completed]
  enum priority: [:low, :medium, :high]

  def desc_for_tasks
   {
      assessment: stage.sub_category.category.assessment,
      stage: stage,
      risk_category: stage.sub_category.category.risk_category(user_id),
      risk_sub_category: stage.sub_category.risk_sub_category(user_id)
    }
  end
end
