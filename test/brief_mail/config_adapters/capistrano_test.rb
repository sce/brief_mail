require 'test_helper'

class ConfigAdaptersCapistranoTest < MiniTest::Unit::TestCase

  def test_api
    cap_vars = MiniTest::Mock.new
    assert adapter = BriefMail::ConfigAdapters::Capistrano.new(cap_vars)

    %w(
      scm
      application
      stage
      previous_release
      current_release
      previous_revision
      current_revision
    ).each do |name|
      assert adapter.respond_to?(name), %(Should respond to "%s" method) % name

      cap_vars.expect(name.to_sym, name)
      assert_equal name, adapter.send(name)
      cap_vars.verify
    end
  end

  def test_from_user_is_set
    cap_vars = MiniTest::Mock.new
    assert adapter = BriefMail::ConfigAdapters::Capistrano.new(cap_vars)

    assert adapter.respond_to?(:from_user), %(Should respond to "from_user" method)

    from_user = { subject: "subject", mailer: "mailer", recipients: %w(one@example.com) }

    cap_vars.expect(:fetch, from_user, [:brief_mail_config])
    assert_equal from_user[:subject], adapter.subject

    cap_vars.expect(:fetch, from_user, [:brief_mail_config])
    assert_equal from_user[:mailer], adapter.mailer

    cap_vars.expect(:fetch, from_user, [:brief_mail_config])
    assert_equal from_user[:recipients], adapter.recipients

    cap_vars.verify
  end

end

