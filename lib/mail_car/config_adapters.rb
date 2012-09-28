require 'mail_car/config_adapters/abstract_adapter'
require 'mail_car/config_adapters/capistrano'

module MailCar
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
