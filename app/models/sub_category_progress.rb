class SubCategoryProgress < ApplicationRecord
  belongs_to :member
  belongs_to :sub_category

  validates :member_id, uniqueness: { scope: :sub_category_id }
  validate :correct_values_for_current_stage_id

  private

  def correct_values_for_current_stage_id
    errors.add(:current_stage_id, "current_stage_id is invalid") unless valid_sub_category_stage
  end

  def valid_sub_category_stage
    sub_category&.stages&.ids&.include? current_stage_id || current_stage_id.nil?
  end
end
