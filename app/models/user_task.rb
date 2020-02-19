class UserTask < ApplicationRecord
  belongs_to :user
  belongs_to :task

  enum status: [:started, :completed]
end
