require 'test_helper'

class ConfigAdaptersAbstractAdapterTest < MiniTest::Unit::TestCase

  def test_api
    assert adapter = BriefMail::ConfigAdapters::AbstractAdapter.new(nil)

    %w(
      scm
      application
      stage
      previous_release
      current_release
      previous_revision
      current_revision

      from_user
      subject
      mailer
      recipients
    ).each do |name|
      assert adapter.respond_to?(name), %(Should respond to "%s" method) % name
      assert adapter.send(name).nil?, %(Should return nil for "%s" method (was "%s")) % [name, adapter.send(name)]
    end
  end

  def test_from_user_is_set
    assert adapter = BriefMail::ConfigAdapters::AbstractAdapter.new(nil)

    def adapter.from_user
      { mailer: "mailer", subject: "subject", recipients: %w(one@example.com) }
    end

    assert_equal "subject", adapter.subject
    assert_equal "mailer", adapter.mailer
    assert_equal %w(one@example.com), adapter.recipients
  end

end
