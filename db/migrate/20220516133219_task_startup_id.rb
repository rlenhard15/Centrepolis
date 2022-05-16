class TaskStartupId < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :startup_id, :bigint
    execute "
UPDATE tasks
SET startup_id = us.startups_id
FROM task_users tu
INNER JOIN users_startups us ON us.user_id = tu.user_id
WHERE tu.task_id = tasks.id
"
    execute "DELETE FROM tasks WHERE startup_id IS NULL"
    add_foreign_key :tasks, :startups, column_name: :startup_id
    change_column_null :tasks, :startup_id, false
  end
end
