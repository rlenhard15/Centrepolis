class Task < ApplicationRecord
  belongs_to :stage
  has_many :user_tasks, dependent: :destroy
  has_many :users, through: :user_tasks
end
