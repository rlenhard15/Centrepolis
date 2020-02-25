class Task < ApplicationRecord
  belongs_to :stage
  belongs_to :user

  enum status: [:started, :completed]
end
