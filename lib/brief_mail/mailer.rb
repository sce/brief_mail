require "action_mailer"

module BriefMail

  # Note mail is sent from the machine doing the deployment, not from the remote host.
  class Mailer < ActionMailer::Base

    def self.load_config(config)
      raise ArgumentError, %(:mailer config is required, and must behave like a Hash) unless config and config.respond_to?(:each_pair)

      config.each_pair do |k, v|
        assign = "#{k}="
        if Mailer.respond_to?(assign)
          Mailer.send(assign, v)
        else
          raise ArgumentError, %("%s" is an invalid ActionMailer config option) % k
        end
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
          render "brief_mail/views/deploy_notification.txt"
        end
      end

      puts %(Sent mail to %s.) % [recipients].join(", ")
    end
  end

end
