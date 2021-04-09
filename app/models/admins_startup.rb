class AdminsStartup < ApplicationRecord
  belongs_to :admin, foreign_key: "admin_id"
  belongs_to :startup
end
