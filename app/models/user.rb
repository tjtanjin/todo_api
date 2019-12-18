class User < ApplicationRecord
  has_secure_password
  has_many :task
  validates :email, presence: true, uniqueness: true
  validates :name, :password, presence: true

  def can_modify_user?(user_id)
    role == 'admin' || id.to_s == user_id.to_s
  end

  # This method tells us if the user is an admin or not.
  def is_admin?
    role == 'admin'
  end

end
