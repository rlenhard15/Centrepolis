class AddColumsToTask < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :user_id, :integer
    add_column :tasks, :status, :integer
  end
end
