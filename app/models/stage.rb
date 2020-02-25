class Stage < ApplicationRecord
  belongs_to :sub_category
  has_many :tasks
end
