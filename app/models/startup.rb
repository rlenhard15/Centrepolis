class Startup < ApplicationRecord
  belongs_to :admin, foreign_key: "created_by"
  has_many :startup_admins, foreign_key: "startup_id"
  has_many :members, foreign_key: "startup_id"
end
