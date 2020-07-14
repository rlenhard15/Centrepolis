class CreateAccelerators < ActiveRecord::Migration[6.0]
  def change
    create_table :accelerators do |t|
      t.string :name

      t.timestamps
    end

    add_column :users, :accelerator_id, :integer
  end
end
