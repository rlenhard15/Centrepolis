class Accelerator < ApplicationRecord
  has_many :users
  has_many :startups
end
