class AddUsersStartups < ActiveRecord::Migration[6.0]
  def change
    create_table :users_startups do |t|
      t.references :users, null: false, foreign_key: true, name: :user_id
      t.references :startups, null: false, foreign_key: true
      t.column :is_team_lead, :boolean, default: false
      t.timestamps
    end
    rename_column :users_startups, :users_id, :user_id
  end
end
