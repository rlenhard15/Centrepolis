class AddPositionToStages < ActiveRecord::Migration[6.0]
  def change
    add_column :stages, :position, :integer
  end
end
