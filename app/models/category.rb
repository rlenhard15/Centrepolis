class Category < ApplicationRecord
  belongs_to :accessment
  has_many :sub_categories
end
