class CreateAccessments < ActiveRecord::Migration[6.0]
  def change
    create_table :accessments do |t|
      t.string :name

      t.timestamps
    end
  end
end
