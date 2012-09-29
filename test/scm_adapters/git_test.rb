require 'test_helper'

class SCMAdaptersGitTest < MiniTest::Unit::TestCase

  def test_api
    config = MiniTest::Mock.new
    assert adapter = BriefMail::SCMAdapters::Git.new(config)

    %w( diff_stat log ).each do |name|
      assert adapter.respond_to?(name), %(Should respond to "%s" method) % name
    end

    %w( subdirs_diff_stat subdirs_log ).each do |name|
      assert adapter.respond_to?(name), %(Should respond to "%s" method) % name
    end
  end

  def test_log
    config = MiniTest::Mock.new
    assert adapter = BriefMail::SCMAdapters::Git.new(config)

    # %x() is syntatic sugar for backtick (`) method:
    adapter.stub(:`, %(Command output)) do
      config.expect :previous_revision, 1
      config.expect :from_user, {}
      assert_equal %(Command output), adapter.log
      config.verify
    end
  end

  def test_diff_stat
    config = MiniTest::Mock.new
    assert adapter = BriefMail::SCMAdapters::Git.new(config)

    adapter.stub(:`, %(Command output)) do
      config.expect :previous_revision, 1
      assert_equal %(Command output), adapter.diff_stat
      config.verify
    end
  end

  def test_subdirs_diff_stat
    config = MiniTest::Mock.new
    assert adapter = BriefMail::SCMAdapters::Git.new(config)

    def Dir.chdir(*args)
      yield if block_given?
    end

    adapter.stub(:`, %(Command output)) do
      config.expect :current_revision, 2
      config.expect :previous_revision, 1
      assert_equal({ "output" => "Command output"}, adapter.subdirs_diff_stat)
      config.verify
    end
  end

  def test_subdirs_log
    config = MiniTest::Mock.new
    assert adapter = BriefMail::SCMAdapters::Git.new(config)

    def Dir.chdir(*args)
      yield if block_given?
    end

    adapter.stub(:`, %(Command output)) do
      config.expect :current_revision, 2
      config.expect :previous_revision, 1
      config.expect :from_user, {}
      assert_equal({ "output" => "Command output"}, adapter.subdirs_log)
      config.verify
    end
  end

end
