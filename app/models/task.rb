class Task < ApplicationRecord
  belongs_to :user
  validates :task_name, :task_description, :category, :deadline, presence: true
  validates_uniqueness_of :task_name, scope: :user_id, conditions: -> { where.not(priority: ['Completed', 'Overdue']) }
  validates_inclusion_of :priority, :in => %w( Low Medium High Completed Overdue )
  validate :deadline_cannot_be_in_the_past

  def deadline_cannot_be_in_the_past
    if deadline.present? && deadline < Date.today
      errors.add(:deadline, "can't be in the past")
    end
  end 
end
