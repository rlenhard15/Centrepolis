class UniqueConstraintUsersStartups < ActiveRecord::Migration[6.0]
  def change
    add_index :users_startups, [:user_id, :startups_id], unique: true
  end
end
