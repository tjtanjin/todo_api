class User < ApplicationRecord
  has_secure_password
  has_many :task, dependent: :delete_all
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
  validates :name, :password, presence: true
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
end
