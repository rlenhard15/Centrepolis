class Startup < ApplicationRecord
  belongs_to :admin, foreign_key: "created_by"
  has_many :startup_admins
  has_many :members
  belongs_to :accelerator
end
