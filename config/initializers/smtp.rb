# config/initializers/smtp.rb
ActionMailer::Base.smtp_settings = {
  address: 'smtp.sendgrid.net',
  port: 587,
  domain: ENV["API_DOMAIN"],
  user_name: ENV["NEW_SENDGRID_KEY"],
  password: ENV["NEW_SENDGRID_PASSWORD"],
  authentication: :login,
  enable_starttls_auto: true
}
