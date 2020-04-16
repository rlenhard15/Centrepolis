class Task < ApplicationRecord
  belongs_to :stage
  belongs_to :admin, foreign_key: "created_by"
  belongs_to :customer, foreign_key: "user_id"

  enum status: [:started, :completed]
  enum priority: [:low, :medium, :high]
end
