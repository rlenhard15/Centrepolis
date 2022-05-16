class MigrateStartupData < ActiveRecord::Migration[6.0]
  def change
    execute "INSERT INTO users_startups(user_id, startups_id, is_team_lead) SELECT id, startup_id, type = 'TeamLead' FROM users WHERE startup_id IS NOT NULL"
    remove_column :users, :startup_id
    execute "UPDATE users SET type = 'Member' WHERE type = 'TeamLead'"
  end
end
