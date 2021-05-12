class AdminsStartup < ApplicationRecord
  belongs_to :admin, foreign_key: "admin_id"
  belongs_to :startup
  belongs_to :accelerator, foreign_key: "accelerator_id"
end
