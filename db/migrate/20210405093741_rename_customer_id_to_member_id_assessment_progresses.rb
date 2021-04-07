class RenameCustomerIdToMemberIdAssessmentProgresses < ActiveRecord::Migration[6.0]
  def change
    rename_column :assessment_progresses, :customer_id, :member_id
  end
end
