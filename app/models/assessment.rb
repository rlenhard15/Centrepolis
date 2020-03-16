class Assessment < ApplicationRecord
  has_many :categories

  def description
     categories.as_json({include: {sub_categories: {include: :stages }}})
  end
end
