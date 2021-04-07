class RenameCustomerIdToMemberIdNotifications < ActiveRecord::Migration[6.0]
  def change
    rename_column :notifications, :customer_id, :member_id
  end
end
