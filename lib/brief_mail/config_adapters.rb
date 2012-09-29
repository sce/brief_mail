require 'brief_mail/config_adapters/abstract_adapter'
require 'brief_mail/config_adapters/capistrano'

module BriefMail
  module ConfigAdapters

    def self.adapter_for(config)
      if defined? ::Capistrano::Configuration and config.is_a? ::Capistrano::Configuration::Namespaces::Namespace
        Capistrano.new(config)
      else
        raise %(Unknown config adapter class: %s) % config.class
      end
    end

  end
end
