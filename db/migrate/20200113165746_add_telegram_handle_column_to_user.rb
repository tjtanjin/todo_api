class AddTelegramHandleColumnToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :telegram_handle, :string
  end
end
