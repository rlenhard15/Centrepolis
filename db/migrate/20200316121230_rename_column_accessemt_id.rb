class RenameColumnAccessemtId < ActiveRecord::Migration[6.0]
  def change
    rename_column :categories, :accessment_id, :assessment_id
  end
end
