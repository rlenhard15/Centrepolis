class Stage < ApplicationRecord
  belongs_to :sub_category
  has_many :tasks, dependent: :destroy

  validates :position, uniqueness: { scope: :sub_category_id, message: "should be uniq for one sub_category" }

  def sub_category_risk(customer_id)
    result_hash = sub_category.calculate_risk_value(customer_id)

    (result_hash[:percentage] / result_hash[:total_number_of_sc]) * 100
  end
end
