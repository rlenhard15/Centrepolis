class SubCategoryProgress < ApplicationRecord
  belongs_to :customer
  belongs_to :sub_category

  validates :current_stage_id, uniqueness: { scope: [:customer_id, :sub_category_id] }
  validates :customer_id, uniqueness: { scope: :sub_category_id }
  validate :correct_values_for_current_stage_id

  private

  def correct_values_for_current_stage_id
    errors.add(:current_stage_id, "current_stage_id is invalid") unless valid_sub_category_stage
  end

  def valid_sub_category_stage
    (sub_category.stages.ids).include?(self.current_stage_id)
  end

end
