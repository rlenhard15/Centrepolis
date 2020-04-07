class Stage < ApplicationRecord
  belongs_to :sub_category
  has_many :tasks, dependent: :destroy

  validates :position, uniqueness: { scope: :sub_category_id, message: "should be uniq for one sub_category" }
end
