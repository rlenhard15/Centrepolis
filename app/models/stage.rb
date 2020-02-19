class Stage < ApplicationRecord
  belongs_to :category
  has_many :tasks  
end
