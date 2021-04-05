class RemoveCompanyNameFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :company_name
  end
end
