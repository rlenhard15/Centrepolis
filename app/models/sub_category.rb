class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :stages, dependent: :destroy
  has_many :sub_category_progresses, dependent: :destroy

  scope :with_stages_progresses, ->(customer_id) {
    includes(:stages).
    joins(Arel.sql("LEFT JOIN sub_category_progresses ON (sub_category_progresses.sub_category_id = sub_categories.id AND sub_category_progresses.customer_id = #{customer_id})"))
  }

  def risk_sub_category(customer_id)
    result_hash = SubCategory.where(id: id).calculate_risk_value(customer_id)

    (result_hash[:percentage] / result_hash[:total_number_of_sc]) * 100
  end

  scope :calculate_risk_value, ->(customer_id) {
    with_stages_progresses(customer_id).
    joins("LEFT JOIN stages ON (stages.id = sub_category_progresses.current_stage_id)").
    select("sub_categories.id, stages.position AS position").
    inject({percentage: 0, total_number_of_sc: 0}) do |result, current_sub|
      result[:percentage] += ( (current_sub.position || 0) / current_sub.stages.length.to_f )
      result[:total_number_of_sc] += 1
      result
    end
  }
end
