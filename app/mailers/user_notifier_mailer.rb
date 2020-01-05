class UserNotifierMailer < ApplicationMailer
  default :from => ENV['SENDGRID_SENDER']

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email(user)
    @user = user
    mail( :to => @user.email ,
    :subject => '[Todo Manager] Welcome!' )
  end

  def send_reset_password_email(user)
  	@user = user
  	mail( :to => @user.email ,
  	:subject => '[Todo Manager] Password Reset')
  end

  def send_farewell_email(user)
    @user = user
    mail( :to => @user.email ,
    :subject => '[Todo Manager] See you again!')
  end
end
