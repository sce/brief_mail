module MailCar
  module ConfigAdapters
    class AbstractAdapter

      def initialize(config)
        @config = config
      end

      %w(
        scm
        application
        stage
        previous_release
        current_release
        previous_revision
        current_revision
      ).each do |name|
        define_method(name) do
          #raise NotImplementedError
          nil
        end
      end

      # The config hash from the user.
      def from_user
        nil
      end

      def subject
        @subject ||= (from_user || {})[:subject]
      end

      def mailer
        @mailer ||= (from_user || {})[:mailer]
      end

      def recipients
        @recipients ||= (from_user || {})[:recipients]
      end

    end
  end
end

