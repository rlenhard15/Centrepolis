class RemoveUserIdFromTasks < ActiveRecord::Migration[6.0]
  def change
    remove_column :tasks, :user_id
  end
end
