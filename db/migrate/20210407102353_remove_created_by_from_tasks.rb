class RemoveCreatedByFromTasks < ActiveRecord::Migration[6.0]
  def change
    remove_column :tasks, :created_by
  end
end
