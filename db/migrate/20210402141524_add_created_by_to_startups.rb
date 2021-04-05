class AddCreatedByToStartups < ActiveRecord::Migration[6.0]
  def change
    add_column :startups, :created_by, :integer
  end
end
