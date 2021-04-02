class CreateStartups < ActiveRecord::Migration[6.0]
  def change
    create_table :startups do |t|
      t.string :name
      t.integer :accelerator_id

      t.timestamps
    end
  end
end
