class CreateTableUsersTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :task_users do |t|
      t.integer :task_id
      t.integer :user_id
      t.boolean :creator, default: false

      t.timestamps
    end
  end
end
