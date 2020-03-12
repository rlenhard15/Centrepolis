class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :stages, dependent: :destroy
end
