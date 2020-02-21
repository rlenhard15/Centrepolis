class Task < ApplicationRecord
  belongs_to :stage
  belongs_to :user

  enum status: [:started, :completed]

  scope :completed_tasks, -> {
    where(status: :completed)
  }
end
