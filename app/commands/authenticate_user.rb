class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    { auth_token: JsonWebToken.encode(user_id: user.id), userName: user.name, isAdmin: user.role === "admin", isLoggedIn: true, isVerified: user.verification_token == "1" } if user
  end

  private

  attr_accessor :email, :password

  def user
    user = User.find_by_email(email)
    return user if user && user.authenticate(password)

    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end
