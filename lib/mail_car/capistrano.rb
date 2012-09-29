require 'mail_car'

Capistrano::Configuration.instance.load do

  namespace :deploy do
    desc "Send email notification"
    task :send_notification do
      MailCar::Mailer.deploy_notification(self).deliver
    end
  end

  after :deploy, "deploy:send_notification"

end
