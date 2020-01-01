class Task < ApplicationRecord
  belongs_to :user
  validates :task_name, presence: true, uniqueness: {scope: :user_id}
  validates :task_description, :category, :deadline, presence: true
  validates_inclusion_of :priority, :in => %w( Low Medium High Completed )
  validate :deadline_cannot_be_in_the_past

  def deadline_cannot_be_in_the_past
    if deadline.present? && deadline < Date.today
      errors.add(:deadline, "can't be in the past")
    end
  end 
end
