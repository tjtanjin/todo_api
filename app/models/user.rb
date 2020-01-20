class User < ApplicationRecord
  has_secure_password
  has_many :task, dependent: :delete_all
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
  validates :password, presence: true, length: { minimum: 6 }
  validates :name, presence: true, length: { minimum: 2, maximum: 24, }
  validate :password_requirements_are_met

  # check if user modification allowed
  def can_modify_user?(user_id)
    role == 'admin' || id.to_s == user_id.to_s
  end

  # check if user is admin
  def is_admin?
    role == 'admin'
  end

  # check if password requirements are met
  def password_requirements_are_met
    rules = {
      " must contain at least one lowercase letter"  => /[a-z]+/,
      " must contain at least one uppercase letter"  => /[A-Z]+/,
      " must contain at least one digit"             => /\d+/,
      " must contain at least one special character" => /[^A-Za-z0-9]+/
    }

    if password != nil
      rules.each do |message, regex|
        errors.add( :password, message ) unless password.match( regex )
      end
    end
  end

  # generate token to reset password
  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    self.save(validate: false)
  end

  # check if password reset token is still valid
  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end

  # generate token to verify user on signup
  def generate_verification_token!
    self.verification_token = generate_token
    self.verification_sent_at = Time.now.utc
    self.save(validate: false)
  end

  # check if verification token is still valid
  def verification_token_valid?
    (self.verification_sent_at + 4.hours) > Time.now.utc
  end

  private

  # generates a secure token
  def generate_token
   SecureRandom.hex(10)
  end

  # checks when a task is expiring and sends a reminder (runs daily at 12am GMT + 8)
  def self.send_reminders
    @users = User.all
    @users.each do |user|
      if user.email_notifications == "1"
        @tasks = user.task
        expiringtasks = Hash.new
        currentDate = Time.now.in_time_zone("Singapore")
        @tasks.each do |task|
          days_left = (Date.strptime(task.deadline.to_s, '%Y-%m-%d') - Date.strptime(currentDate.to_s, '%Y-%m-%d')).to_i
          if days_left <= 3 and days_left >= 0 and task.priority != "Completed" and task.priority != "Overdue"
            if days_left == 0
              days_left = "Today"
            else
            end
            expiringtasks[task.task_name] = days_left
          else
          end
        end
        if not expiringtasks.blank? 
          UserNotifierMailer.send_reminder_email(user, expiringtasks).deliver
        else
        end
      end
    end
  end
end
