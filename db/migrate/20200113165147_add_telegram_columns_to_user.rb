class AddTelegramColumnsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :telegram_notifications, :string, default: '0'
    add_column :users, :telegram_id, :string    
  end
end
