class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :stages, :category_id, :sub_category_id
  end
end
