class AddNotificationsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :notifications, :string, default: '0'
  end
end
