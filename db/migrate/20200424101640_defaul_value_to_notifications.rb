class DefaulValueToNotifications < ActiveRecord::Migration[6.0]
  def change
    change_column :notifications, :read, :boolean, default: false
  end
end
