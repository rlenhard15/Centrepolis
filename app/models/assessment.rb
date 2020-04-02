class Assessment < ApplicationRecord
  has_many :categories, dependent: :destroy
  has_many :assessment_progresses, dependent: :destroy

  def with_value_risk(customer_id)
    assessment_progresses.where(customer_id: customer_id)
  end

  def description_with_child_models
    categories.as_json({include: {sub_categories: {include: :stages }}})
  end
end
