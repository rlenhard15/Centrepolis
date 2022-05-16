class UsersStartup < ApplicationRecord
  self.table_name <- 'users_startups'
  belongs_to :user, foreign_key: 'user_id'
  belongs_to :startup, foreign_key: 'startups_id'
end
