class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :company_name, :string
    add_index :users, :company_name, unique: true
    add_column :users, :type, :string
    add_column :users, :created_by, :integer
  end
end
