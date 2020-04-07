class CreateAssessmentProgresses < ActiveRecord::Migration[6.0]
  def change
    create_table :assessment_progresses do |t|
      t.integer :customer_id
      t.integer :assessment_id
      t.decimal :risk_value

      t.timestamps
    end
  end
end
