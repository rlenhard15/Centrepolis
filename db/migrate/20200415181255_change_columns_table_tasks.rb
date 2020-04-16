class ChangeColumnsTableTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :created_by, :integer
    change_column :tasks, :status, :integer, default: 0
  end
end
