class Accelerator < ApplicationRecord
  has_many :admins, foreign_key: "accelerator_id"
  has_many :startup_admins, foreign_key: "accelerator_id"
  has_many :members, foreign_key: "accelerator_id"
  has_many :startups
end
