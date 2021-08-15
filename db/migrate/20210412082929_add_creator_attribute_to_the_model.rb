class AddCreatorAttributeToTheModel < ActiveRecord::Migration[6.0]
  def change
    add_column :task_users, :creator, :boolean, default: false
  end
end
