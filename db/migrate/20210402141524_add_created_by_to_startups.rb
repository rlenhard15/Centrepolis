class AddCreatedByToStartups < ActiveRecord::Migration[6.0]
  def change
    add_column :startups, :created_for, :integer
  end
end
