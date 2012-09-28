module MailCar
  module ConfigAdapters
    class Capistrano < AbstractAdapter

      def initialize(cap_vars)
        @cap_vars = cap_vars
      end

      def scm
        @cap_vars.scm
      end

      def subject
        @cap_vars.fetch(:mail_car_config, {})[:subject]
      end

      def mailer
        @cap_vars.fetch(:mail_car_config, {})[:mailer]
      end

      def recipients
        @cap_vars.fetch(:mail_car_config, {})[:recipients]
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
