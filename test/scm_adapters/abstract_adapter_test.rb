require 'test_helper'

class SCMAdaptersAbstractAdapterTest < MiniTest::Unit::TestCase

  def test_api
    assert adapter = BriefMail::SCMAdapters::AbstractAdapter.new(nil)

    %w( diff_stat log ).each do |name|
      assert adapter.respond_to?(name), %(Should respond to "%s" method) % name
      assert adapter.send(name).nil?
    end

    %w( subdirs_diff_stat subdirs_log ).each do |name|
      assert adapter.respond_to?(name), %(Should respond to "%s" method) % name
      assert_equal Hash.new, adapter.send(name)
    end
  end

end
