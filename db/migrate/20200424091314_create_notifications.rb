class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.integer :task_id
      t.integer :customer_id
      t.boolean :read

      t.timestamps
    end
  end
end
