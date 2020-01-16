class UserNotifierMailer < ApplicationMailer
  default :from => ENV['SENDGRID_SENDER']

  # send a signup email to the user
  def send_signup_email(user)
    @user = user
    mail( :to => @user.email ,
    :subject => '[Todo Manager] Welcome!' )
  end

  # send a reset password email to the user
  def send_reset_password_email(user)
  	@user = user
  	mail( :to => @user.email ,
  	:subject => '[Todo Manager] Password Reset')
  end

  # send a farewell email to the user
  def send_farewell_email(user)
    @user = user
    mail( :to => @user.email ,
    :subject => '[Todo Manager] See you again!')
  end

  # send a reminder email to the user
  def send_reminder_email(user, expiringtasks)
    @user = user
    @expiringtasks = expiringtasks
    mail( :to => @user.email ,
    :subject => '[Todo Manager] Task Reminder')
  end
end
