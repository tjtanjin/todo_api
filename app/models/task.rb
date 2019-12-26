class Task < ApplicationRecord
  belongs_to :user
  validates :task_name, presence: true, uniqueness: {scope: :user_id}
  validates :task_description, :category, presence: true

end
