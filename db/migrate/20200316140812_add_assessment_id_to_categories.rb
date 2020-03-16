class AddAssessmentIdToCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :assessment_id, :integer
  end
end
