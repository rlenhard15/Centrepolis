class AddFieldsToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :priority, :integer
    add_column :tasks, :due_date, :datetime
  end
end
