class Assessment < ApplicationRecord
  has_many :categories, dependent: :destroy

  def description_with_child_models
     categories.as_json({include: {sub_categories: {include: :stages }}})
  end
end
