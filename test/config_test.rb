require_relative './test_helper'
require 'tumugi/config'

class Tumugi::ConfigTest < Test::Unit::TestCase
  setup do
    @config = Tumugi::Config.new
  end

  test 'default value' do
    assert_equal(1, @config.workers)
    assert_equal(3, @config.max_retry)
    assert_equal(300, @config.retry_interval)
    assert_equal(true, @config.param_auto_bind_enabled)
  end

  sub_test_case '#sections' do
    test 'should create different hash for different name' do
      @config.section('name1') { |s| s['key'] = 'value1' }
      @config.section('name2') { |s| s['key'] = 'value2' }

      assert_not_same(@config.section('name1'), @config.section('name2'))
      assert_equal('value1', @config.section('name1')['key'] )
      assert_equal('value2', @config.section('name2')['key'] )
    end
  end
end
