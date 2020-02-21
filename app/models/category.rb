class Category < ApplicationRecord
  has_many :sub_categories

  def list_of_sub_categories
    sub_categories.map { |sub_category| sub_category.title }
  end

  def list_of_stages
    sub_categories.map {|sub_category| sub_category.stages }
  end

  def status_of_category
    completed_stages = check_completed_stage.flatten.select{|stage| stage == true}.count

    progress_percent = (completed_stages.to_f / count_stage.to_f)*100
    sprintf( "%.02f", progress_percent)
  end

  private

  def count_stage
    sub_categories.map {|sub_category| sub_category.stages.count }.reduce(:+)
  end

  def check_completed_stage
    sub_categories.map do |sub_category|
      sub_category.stages.map {|stage| stage.tasks.count == stage.completed_tasks_for_stage.count }
    end
  end
end
