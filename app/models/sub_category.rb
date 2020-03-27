class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :stages, dependent: :destroy
  has_many :sub_category_progresses, dependent: :destroy

  def count_stages
    stages.count
  end

  def sub_category_status
    sub_category_progresses.map do |progress|
      current_status = stages.find(progress.current_stage_id).position
      {current_stage: current_status, total_stages: count_stages }
    end
  end
end
