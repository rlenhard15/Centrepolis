class Stage < ApplicationRecord
  belongs_to :sub_category
  has_many :tasks

  def completed_tasks_for_stage
    tasks.completed_tasks.count
  end

  def tasks_for_stage
    tasks.count
  end


end
