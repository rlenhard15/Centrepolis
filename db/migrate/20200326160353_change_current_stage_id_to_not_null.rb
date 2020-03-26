class ChangeCurrentStageIdToNotNull < ActiveRecord::Migration[6.0]
  def change
    change_column :sub_category_progresses, :current_stage_id, :bigint, null: false
  end
end
