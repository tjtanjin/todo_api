class ChangeColumnNameIsVerified < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :isVerified, :verification_token
  end
end
