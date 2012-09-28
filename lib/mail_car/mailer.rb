require "action_mailer"

module MailCar

  # Note mail is sent from the machine doing the deployment, not from the remote host.
  class Mailer < ActionMailer::Base

    def self.load_config(config)
      if config.is_a? Symbol
        Mailer.delivery_method = config

      elsif config.is_a? Hash
        Mailer.delivery_method = :smtp
        Mailer.smtp_settings = config

      else
        raise ArgumentError, %(mail_car_config.mailer must either be ActionMailer delivery method (as symbol) or SMTP settings as hash)
      end
    end

    def deploy_notification(config)
      @config = ConfigAdapters.adapter_for(config)
      @scm = SCMAdapters.adapter_for(@config.scm, @config)
      Mailer.load_config(@config.mailer)

      # Add lib directory for this gem to view path:
      view_paths << File.expand_path("../../", __FILE__)

      recipients = @config.recipients
      subj = @config.subject || %([DEPLOY] %s deployed to %s) % [@config.application, @config.stage]

      mail( to: recipients, subject: subj ) do |format|
        format.text do
          render "mail_car/views/deploy_notification.txt"
        end
      end

      puts %(Sent mail to %s.) % [recipients].join(", ")
    end
  end

end
