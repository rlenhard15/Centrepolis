class DropUserTask < ActiveRecord::Migration[6.0]
  def change
    drop_table :user_tasks
  end
end
