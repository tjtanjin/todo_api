class ChangeDeadlineInUsers < ActiveRecord::Migration[6.0]
  def change
    change_column(:tasks, :deadline, "date USING CAST(case when deadline = '' then null else deadline end AS date)")
  end
end
