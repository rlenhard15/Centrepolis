class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :stages

  def count_stages
    stages.count
  end

  def completed_stage?
    stages.map {|stage| stage.tasks.count == stage.completed_tasks_for_stage.count }
  end

end
