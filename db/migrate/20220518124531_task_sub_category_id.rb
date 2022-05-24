class TaskSubCategoryId < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :sub_category_id, :bigint
    add_foreign_key :tasks, :sub_categories, column: :sub_category_id
    execute "UPDATE tasks SET sub_category_id = stages.sub_category_id FROM stages WHERE stages.id = tasks.stage_id"
    change_column :tasks, :sub_category_id, :bigint, null: false
  end
end
