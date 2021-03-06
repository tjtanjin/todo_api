class Task < ApplicationRecord
  belongs_to :user
  validates :deadline, presence: true
  validates :task_name, presence: true, length: { maximum: 128, }
  validates :task_description, presence: true, length: { maximum: 256, }
  validates :category, presence: true, length: { maximum: 64, }
  validates_uniqueness_of :task_name, scope: :user_id, conditions: -> { where.not(priority: ['Completed', 'Overdue']) }
  validates_inclusion_of :priority, :in => %w( Low Medium High Completed Overdue )
  validate :deadline_cannot_be_in_the_past

  # reject if deadline set in the past
  def deadline_cannot_be_in_the_past
    if deadline.present? && deadline < Date.today
      errors.add(:deadline, "can't be in the past")
    end
  end 

  # checks when a task is overdue (runs daily at 12am GMT + 8)
  def self.check_overdue
    @tasks = Task.all
    currentDate = Time.now.in_time_zone("Singapore")
    @tasks.each do |task|
      days_left = (Date.strptime(task.deadline.to_s, '%Y-%m-%d') - Date.strptime(currentDate.to_s, '%Y-%m-%d')).to_i
      if days_left < 0 and task.priority != "Completed" and task.priority != "Overdue"
        task.priority = "Overdue"
        task.save(validate: false)
      else
      end
    end
  end
end
