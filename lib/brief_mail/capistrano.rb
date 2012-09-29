require 'brief_mail'

Capistrano::Configuration.instance.load do

  namespace :deploy do
    desc "Send email notification"
    task :send_notification do
      BriefMail::Mailer.deploy_notification(self).deliver
    end
  end

  after :deploy, "deploy:send_notification"

end
