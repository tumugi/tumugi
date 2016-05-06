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
end
