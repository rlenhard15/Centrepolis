class RenameColumnCustomerIdToMemberId < ActiveRecord::Migration[6.0]
  def change
    rename_column :assessment_progresses, :customer_id, :member_id
    rename_column :notifications, :customer_id, :member_id
    rename_column :sub_category_progresses, :customer_id, :member_id
  end
end
