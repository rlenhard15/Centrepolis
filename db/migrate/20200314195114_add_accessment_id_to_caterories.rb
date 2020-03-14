class AddAccessmentIdToCaterories < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :accessment_id, :integer
  end
end
