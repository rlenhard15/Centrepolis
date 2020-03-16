class Category < ApplicationRecord
  belongs_to :assessment
  has_many :sub_categories, dependent: :destroy
end
