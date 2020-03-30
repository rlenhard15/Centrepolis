class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :stages, dependent: :destroy
  has_many :sub_category_progresses, dependent: :destroy

  # def current_customer(user_id)
  #   where("sub_category_progresses.customer_id = ?", user_id)
  # end
  #
  #
  # def sub_category_status(user_id)
  #   sub_category_progresses.where("sub_category_progresses.customer_id = ?", user_id).map do |progress|
  #     progress.current_stage_id
  #   end
  # end
  # def sub_category_status(user_id)
  #  sub_category_progresses.where("sub_category_progresses.customer_id = ?", user_id).map do |progress|
  #     {
  #       stages: self.stages,
  #       current_stage_id: progress.current_stage_id
  #     }
  #     end
  #    end
end
