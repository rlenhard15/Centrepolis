class AddHostnameToAccelerators < ActiveRecord::Migration[6.0]
  def change
    add_column :accelerators, :hostname, :string
  end
end
