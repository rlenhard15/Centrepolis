class Category < ApplicationRecord
  has_many :sub_categories

  def status_of_category
    completed_stages = check_completed_stage.flatten.select{|stage| stage == true}.count

    progress_percent = (completed_stages.to_f / count_stage.to_f)*100
    sprintf( "%.02f", progress_percent)
  end

  private

  def count_stage
    sub_categories.map {|sub_category| sub_category.count_stages }.reduce(:+)
  end

  def check_completed_stage
    sub_categories.map {|sub_category| sub_category.completed_stage? }
  end
end
