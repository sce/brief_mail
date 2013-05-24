require 'brief_mail/config_adapters/abstract_adapter'
require 'brief_mail/config_adapters/capistrano'

module BriefMail
  module ConfigAdapters
    Error = Class.new RuntimeError

    class ArgumentError < Error
      def initialize(config)
        super %(Config object (%s) needs to respond to the following methods: %s.) %
          [config.class, ConfigAdapters.missing_responses(config).join(", ")]
      end
    end

    def self.adapter_for(config)
      if capistrano?(config)
        Capistrano.new(config)

      elsif responds_properly?(config)
        config

      else
        fail ArgumentError, config
      end
    end

    def self.capistrano?(config)
      defined? ::Capistrano::Configuration and
        config.is_a? ::Capistrano::Configuration::Namespaces::Namespace
    end

    def self.responds_properly?(config)
      missing_responses(config).empty?
    end

    def self.missing_responses(config)
      EXPECTED_METHODS.reject do |meth|
        config.respond_to? meth
      end
    end

    private

    EXPECTED_METHODS = [
      :application,
      :current_release,
      :current_revision,
      :from_user,
      :mailer,
      :previous_release,
      :previous_revision,
      :recipients,
      :scm,
      :stage,
      :subject,
    ].freeze
  end
end
