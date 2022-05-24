class DevelopmentStatusTrl < ActiveRecord::Migration[6.0]
  def change
    execute "UPDATE sub_categories SET category_id = 5 WHERE id = 1"
  end
end
