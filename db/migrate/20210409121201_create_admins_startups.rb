class CreateAdminsStartups < ActiveRecord::Migration[6.0]
  def change
    create_table :admins_startups do |t|
      t.integer :startup_id
      t.integer :admin_id

      t.timestamps
    end
  end
end
