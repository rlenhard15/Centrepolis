class RemoveColumnCreatedForTasks < ActiveRecord::Migration[6.0]
  def change
    remove_column :tasks, :created_for
  end
end
