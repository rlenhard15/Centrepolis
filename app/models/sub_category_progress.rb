class SubCategoryProgress < ApplicationRecord
  belongs_to :customer
  belongs_to :sub_category

  validates :current_stage_id, uniqueness: { scope: [:customer_id, :sub_category_id] }
  validate :correct_values_for_current_stage_id

  def sub_category_stages
    sub_category.stages.ids
  end

  private

  def correct_values_for_current_stage_id
    if self.current_stage_id.blank?
      errors.add(:current_stage_id, "current_stage_id cannot be blank")
    elsif sub_category_stages.exclude?(self.current_stage_id)
      errors.add(:current_stage_id, "current_stage_id is invalid")
    end
  end

end
