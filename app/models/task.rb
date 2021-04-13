class Task < ApplicationRecord
  belongs_to :stage
  has_many :task_users, dependent: :destroy
  has_many :users, through: :task_users

  accepts_nested_attributes_for :task_users

  enum status: [:started, :completed]
  enum priority: [:low, :medium, :high]

  scope :with_all_required_info_for_tasks, -> {
    joins(stage: [sub_category: [category: :assessment]]).select(
      "tasks.id, tasks.title, tasks.priority, tasks.due_date, tasks.status,
      assessments.name AS master_assessment,
      categories.title AS category,
      sub_categories.title AS sub_category,
      stages.title AS stage_title"
    )
  }

  scope :tasks_for_user, ->(user_id) { joins(:users).where("users.id = ?", user_id) }

  def members_for_task
    users.where("users.type = ?", "Member")
  end
end
