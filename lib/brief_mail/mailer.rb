require "action_mailer"

module BriefMail

  # Note mail is sent from the machine doing the deployment, not from the remote host.
  class Mailer
    def self.deploy_notification(conf)
      config = ConfigAdapters.adapter_for(conf)
      scm = SCMAdapters.adapter_for(config.scm, config)

      ActionMailer.load_config(config.mailer)
      ActionMailer.deploy_notification(config, scm)
    end
  end

  class ActionMailer < ActionMailer::Base
    def self.load_config(config)
      unless config and config.respond_to?(:each_pair)
        fail ArgumentError, %(:mailer config is required, and must behave like a Hash.)
      end

      config.each_pair do |k, v|
        assign = "#{k}="
        if respond_to?(assign)
          send(assign, v)
        else
          fail ArgumentError, %("%s" is an invalid ActionMailer config option.) % k
        end
      end
    end

    def deploy_notification(config, scm)
      # Add lib directory for this gem to view path:
      view_paths << File.expand_path("../../", __FILE__)

      conf = {
        to: config.recipients,
        subject: config.subject || %([DEPLOY] %s deployed to %s) % [config.application, config.stage],
      }

      fail ArgumentError, %(One or more recipients are required.) unless conf[:to]

      # In case of sendmail we might not want to specify "from" (sendmail will
      # fill in automatically).
      conf[:from] = config.from if config.from
      template = config.from_user[:template] || "brief_mail/views/deploy_notification.txt"

      @config, @scm = config, scm
      mail( conf ) do |format|
        txt = render(template)
        format.text { txt }
      end

      puts %(Sent mail to %s.) % [conf[:to]].join(", ")
    end
  end

end
