module BriefMail

  # We specify the Error constant in its own file to prevent circular
  # dependencies.
  #
  # This is the root of the exception hierarchy in BriefMail.
  #
  #   begin
  #     # ...
  #   rescue BriefMail::Error => e
  #     $stderr.puts %(BriefMail is being stupid, continuing anyway...)
  #   end
  Error = Class.new RuntimeError

  # Missing or invalid configuration option.
  class ConfigError < Error
    def initialize(field, value, msg=nil)
      txt = %(Missing or invalid configuration option "%s" (was "%s")) % [field, value.inspect]
      txt += %(: %s) % msg if msg

      super txt
    end
  end
end
