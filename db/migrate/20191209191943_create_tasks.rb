class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :job_name
      t.string :job_desc
      t.string :category
      t.string :tag
      t.string :due

      t.timestamps
    end
  end
end
