class DeleteAdminStartups < ActiveRecord::Migration[6.0]
  def change
    drop_table :admins_startups
  end
end
