class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :tasks, :job_name, :task_name
    rename_column :tasks, :job_desc, :task_description
    rename_column :tasks, :tag, :priority
    rename_column :tasks, :due, :deadline
  end
end
