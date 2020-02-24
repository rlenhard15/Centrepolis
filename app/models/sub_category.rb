class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :stages

  def count_stages
    stages.count
  end

end
