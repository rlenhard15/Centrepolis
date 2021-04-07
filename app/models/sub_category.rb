class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :stages, dependent: :destroy
  has_many :sub_category_progresses, dependent: :destroy

  scope :with_stages_progresses, ->(member_id) {
    includes(:stages).
    joins(Arel.sql("LEFT JOIN sub_category_progresses ON (sub_category_progresses.sub_category_id = sub_categories.id AND sub_category_progresses.member_id = #{member_id})"))
  }
end
