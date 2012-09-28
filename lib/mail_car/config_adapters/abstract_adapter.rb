module MailCar
  module ConfigAdapters
    class AbstractAdapter

      def initialize(config)
        @config = config
      end

      %w(
        subject
        mailer
        recipients

        scm
        application
        stage
        previous_release
        current_release
        previous_revision
        current_revision
      ).each do |name|
        define_method(name) do
          raise NotImplementedError
        end
      end

      # def subject
      #   raise NotImplementedError
      # end

      # def mailer
      #   raise NotImplementedError
      # end

      # def recipients
      #   raise NotImplementedError
      # end

      # def scm
      #   raise NotImplementedError
      # end

      # def application
      #   raise NotImplementedError
      # end

      # def stage
      #   raise NotImplementedError
      # end

      # def previous_release
      #   raise NotImplementedError
      # end

      # def current_release
      #   raise NotImplementedError
      # end

      # def previous_revision
      #   raise NotImplementedError
      # end

      # def current_revision
      #   raise NotImplementedError
      # end

    end
  end
end

