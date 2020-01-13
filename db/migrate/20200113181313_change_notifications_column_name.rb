class ChangeNotificationsColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :notifications, :email_notifications
  end
end
