require 'brief_mail/scm_adapters/abstract_adapter'
require 'brief_mail/scm_adapters/git'

module BriefMail
  module SCMAdapters

    def self.adapter_for(scm_name, config)
      case scm_name.to_s
      when /\Agit\z/i then Git.new(config)
      else
        raise %(Unknown scm adapter name: "%s") % scm_name.to_s
      end
    end

  end
end

