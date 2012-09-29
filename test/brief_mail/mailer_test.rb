require 'test_helper'

module Capistrano
  module Configuration
    module Namespaces
      class Namespace
      end
    end
  end
end

class MailerTest < MiniTest::Unit::TestCase

  def test_deploy_notification
    config = MiniTest::Mock.new
    config.expect :is_a?, true, [Capistrano::Configuration::Namespaces::Namespace]
    config.expect :scm, :git

    config.expect :previous_release, "/tmp/prev"
    config.expect :current_release, "/tmp/current"

    # We use real revisions from this git repository during testing because
    # MiniTest can't stub methods on non-existant instances. This means real
    # git commands will be executed as well: Not optimal ...
    4.times { config.expect :previous_revision, "dd1afc4"}
    config.expect :current_revision, "d461201"

    2.times { config.expect :stage, "test" }
    2.times { config.expect :application, "Test Application" }

    from_user = { mailer: { delivery_method: :test }, recipients: %w(test@example.com) }
    4.times { config.expect(:fetch, from_user, [:brief_mail_config]) }

    def Dir.chdir(*args)
      yield if block_given?
    end

    mail = BriefMail::Mailer.deploy_notification(config)

    config.verify

    assert body = mail.body.to_s
    assert_match /Test Application has been deploy to test/, body
    assert_match /2012-09-29 Rakefile: Setup test environment with MiniTest/, body
    assert_match /README\.md\s+\|\s+\d+ \++/, body
  end

end
