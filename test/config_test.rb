require_relative './test_helper'
require 'tumugi/config'

class Tumugi::ConfigTest < Test::Unit::TestCase
  setup do
    @config = Tumugi::Config.new
  end

  teardown do
    Tumugi::Config.reset_config_sections
  end

  test 'default value' do
    assert_equal(1, @config.workers)
    assert_equal(3, @config.max_retry)
    assert_equal(300, @config.retry_interval)
    assert_equal(0, @config.timeout)
  end

  data(
    "single word" => ["Single", "single"],
    "snake case" => ["SnakeCase", "snake_case"],
  )
  test '#camelize' do |(expected, data)|
    assert_equal(expected, Tumugi::Config.camelize(data))
  end

  sub_test_case '#section' do
    test 'should create different struct for different name' do
      Tumugi::Config.register_section('name1', :key1)
      Tumugi::Config.register_section('name2', :key1, :key2)

      @config.section('name1') { |s| s.key1 = 'value1' }
      @config.section('name2') { |s| s.key1 = 'value2' }

      assert_not_same(@config.section('name1'), @config.section('name2'))
      assert_equal('value1', @config.section('name1').key1 )
      assert_equal('value2', @config.section('name2').key1 )
    end

    test 'raise error when section is not registered before call' do
      assert_raise(Tumugi::ConfigError) do
        @config.section('not_registered_section')
      end
    end

    test 'raise error when change section value' do
      Tumugi::Config.register_section('name3', :key3)
      assert_raise(Tumugi::ConfigError) do
        config = @config.clone.freeze
        config.section('name3') { |s| s.key3 = 'value3' }
        section = config.section('name3')
        assert_equal('value3', section.key3)
        section.key3 = 'another value'
      end
    end
  end
end
