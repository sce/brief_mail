module BriefMail
  module ConfigAdapters
    class Capistrano < AbstractAdapter

      def initialize(cap_vars)
        @cap_vars = cap_vars
      end

      def from_user
        @cap_vars.fetch(:brief_mail_config)
      end

      def scm
        @cap_vars.scm
      end

      def application
        @cap_vars.application
      end

      def stage
        @cap_vars.stage
      end

      def previous_release
        @cap_vars.previous_release
      end

      def current_release
        @cap_vars.current_release
      end

      def previous_revision
        @cap_vars.previous_revision
      end

      def current_revision
        @cap_vars.current_revision
      end

    end
  end
end
