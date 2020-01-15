desc "This task is called by the Heroku scheduler add-on"
task :send_reminders => :environment do
  User.send_reminders
end
task :check_overdue => :environment do
  Task.check_overdue
end
