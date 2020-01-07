class User < ApplicationRecord
  has_secure_password
  has_many :task, dependent: :delete_all
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
  validates :password, presence: true, length: { minimum: 6 }
  validates :name, presence: true, length: { minimum: 2, maximum: 24, }
  validate :password_requirements_are_met

  def can_modify_user?(user_id)
    role == 'admin' || id.to_s == user_id.to_s
  end

  # This method tells us if the user is an admin or not.
  def is_admin?
    role == 'admin'
  end

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

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    self.save(validate: false)
  end

  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def generate_verification_token!
    self.verification_token = generate_token
    self.verification_sent_at = Time.now.utc
    self.save(validate: false)
  end

  def verification_token_valid?
    (self.verification_sent_at + 4.hours) > Time.now.utc
  end

  private

  def generate_token
   SecureRandom.hex(10)
  end

  def self.send_reminders
    @users = User.all
    @users.each do |user|
      if user.notifications === "1"
        @tasks = user.task
        expiringtasks = Hash.new
        @tasks.each do |task|
          days_left = (Date.strptime(task.deadline.to_s, '%Y-%m-%d') - DateTime.now).to_i
          if days_left <= 3 and days_left >= 1 and task.priority != "Completed" and task.priority != "Overdue"
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
