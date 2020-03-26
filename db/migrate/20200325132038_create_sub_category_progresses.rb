class CreateSubCategoryProgresses < ActiveRecord::Migration[6.0]
  def change
    create_table :sub_category_progresses do |t|
      t.bigint :customer_id
      t.bigint :sub_category_id
      t.bigint :current_stage_id

      t.timestamps
    end
  end
end
