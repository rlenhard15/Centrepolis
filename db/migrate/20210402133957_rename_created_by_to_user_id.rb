class RenameCreatedByToUserId < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :created_by, :startup_id
  end
end
