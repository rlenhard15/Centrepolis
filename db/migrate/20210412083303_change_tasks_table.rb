class ChangeTasksTable < ActiveRecord::Migration[6.0]
  def change
    tasks = Task.all

    tasks.each do |t|
      TaskUser.create(task_id: t.id, user_id: t.user_id)
      TaskUser.create(task_id: t.id, user_id: t.created_by, creator: true)
    end

    remove_column :tasks, :created_by
    remove_column :tasks, :user_id
  end
end
