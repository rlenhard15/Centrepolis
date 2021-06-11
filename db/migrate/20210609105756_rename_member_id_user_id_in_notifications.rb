class RenameMemberIdUserIdInNotifications < ActiveRecord::Migration[6.0]
  def change
    rename_column :notifications, :member_id, :user_id
  end
end
