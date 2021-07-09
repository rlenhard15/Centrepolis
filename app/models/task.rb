class Task < ApplicationRecord
  belongs_to :stage
  has_many :task_users, dependent: :destroy
  has_many :users, through: :task_users
  has_many :notifications, dependent: :destroy

  after_create :create_notifications

  paginates_per 10

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

  scope :tasks_for_startup, ->(startup_id) { where("users.startup_id = ?", startup_id) }

  def created_by
    users.where("task_users.creator IS true").first
  end

  def members_for_task
    users.where("users.type = ?", "Member")
  end

  def startup_users_for_task
    users.where(type: ["TeamLead", "Member"])
  end

  def users_for_task
    users.select("users.*, users.type AS user_type")
  end

  private

    def create_notifications
      users_for_notifications = user_ids_for_notifications users

      notifications.create(users_for_notifications)
    end

    def user_ids_for_notifications users
      users.map{ |u| {user_id: u.id}}
    end
end
