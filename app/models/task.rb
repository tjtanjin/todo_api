class Task < ApplicationRecord
  belongs_to :user
  validates :job_name, presence: true, uniqueness: {scope: :user_id}
  validates :job_desc, :category, presence: true

end
