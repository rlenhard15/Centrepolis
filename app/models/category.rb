class Category < ApplicationRecord
  has_many :stages
  has_many :sub_categories
end
