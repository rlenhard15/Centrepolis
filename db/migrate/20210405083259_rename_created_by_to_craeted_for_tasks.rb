class RenameCreatedByToCraetedForTasks < ActiveRecord::Migration[6.0]
  def change
    rename_column :tasks, :created_by, :created_for
  end
end
