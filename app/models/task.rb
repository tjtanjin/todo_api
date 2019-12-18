class Task < ApplicationRecord
  belongs_to :user
  validates :job_name, presence: true, uniqueness: true
  validates :job_desc, :category, presence: true

end
