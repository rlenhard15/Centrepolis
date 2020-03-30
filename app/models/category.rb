class Category < ApplicationRecord
  belongs_to :assessment
  has_many :sub_categories, dependent: :destroy

  scope :current_assessment, ->(assessment_id) {
    where(assessment_id: assessment_id)
  }

  def desc_info_for_category
    sub_categories.as_json({ include: :stages })
  end
end
