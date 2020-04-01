class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :stages, dependent: :destroy
  has_many :sub_category_progresses, dependent: :destroy
end
