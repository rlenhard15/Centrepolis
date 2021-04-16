class ChangeTasksTable < ActiveRecord::Migration[6.0]
  def change
    tasks = Task.all

    tasks.each do |t|
      user = Member.find_by_id(t.user_id)
      admin = Admin.find_by_id(t.created_by)

      if user && admin
        TaskUser.create(task_id: t.id, user_id: user.id)
        TaskUser.create(task_id: t.id, user_id: admin.id)
      end
    end

    remove_column :tasks, :created_by
    remove_column :tasks, :user_id
  end
end
