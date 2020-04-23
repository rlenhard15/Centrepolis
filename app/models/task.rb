class Task < ApplicationRecord
  belongs_to :stage
  belongs_to :admin, foreign_key: "created_by"
  belongs_to :customer, foreign_key: "user_id"

  enum status: [:started, :completed]
  enum priority: [:low, :medium, :high]

  scope :with_all_required_info_for_tasks, -> {
    joins(stage: [sub_category: [category: :assessment]]).select(
      "tasks.id, tasks.title, tasks.priority, tasks.due_date,
      assessments.name AS master_assessment,
      categories.title AS risk_category,
      sub_categories.title AS risk_sub_category,
      stages.title AS stage_title"
    )
  }
end
