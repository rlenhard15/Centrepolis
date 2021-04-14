class ChangeUserModel < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :startup_id, :integer
    User.reset_column_information

    customers = Customer.all
    customers.update_all(type: "Member")
    members = Member.all

    members&.each do |m|
      startup = Startup.create(accelerator_id: m.accelerator_id, name: m.company_name)
      AdminsStartup.create(admin_id: m.created_by, startup_id: startup.id)
      m.update(startup_id: startup.id)
    end

    remove_column :users, :created_by
    remove_column :users, :company_name
  end
end
