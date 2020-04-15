class ChangeDefaultValueTasks < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :status, :integer, default: 0
  end
end
