class RenameMemberIdToStartupId < ActiveRecord::Migration[6.0]
  def change
    rename_column :assessment_progresses, :member_id, :startup_id
    rename_column :sub_category_progresses, :member_id, :startup_id
  end
end
