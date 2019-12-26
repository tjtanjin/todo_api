class AddDefaultRoleForUser < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :role, from: nil, to: "user"
  end
end
