class Accelerator < ApplicationRecord
  has_many :admins, foreign_key: "accelerator_id"
  has_many :team_leads, foreign_key: "accelerator_id"
  has_many :members, foreign_key: "accelerator_id"
  has_many :startups
end
