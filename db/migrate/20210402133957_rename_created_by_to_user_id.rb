class RenameCreatedByToUserId < ActiveRecord::Migration[6.0]
  def change
    customer_users = User.where(type: "Customer")
    customer_users.update_all(type: "Member")
    
    rename_column :users, :created_by, :startup_id
  end
end
