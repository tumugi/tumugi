require_relative './test_helper'

class TumugiTest < Test::Unit::TestCase
  test 'it has a version number' do
    refute_nil ::Tumugi::VERSION
  end

  sub_test_case '#workflow' do
    test 'returns Tumugi::Workflow instance' do
      assert_equal(Tumugi::Workflow, Tumugi.workflow.class)
    end

    test 'returns same instance when called multiple' do
      assert_same(Tumugi.workflow, Tumugi.workflow)
    end
  end

  test 'alias methods of #workflow' do
    assert_same(Tumugi.workflow, Tumugi.app)
    assert_same(Tumugi.workflow, Tumugi.application)
  end

  sub_test_case '#logger' do
    test 'returns Tumugi::Logger instance' do
      assert_equal(Tumugi::Logger, Tumugi::Logger.instance.class)
    end

    test 'returns same instance when called multiple' do
      assert_same(Tumugi::Logger.instance, Tumugi::Logger.instance)
    end

    test 'should respond to delegated methods' do
      [:debug, :error, :fatal, :info, :warn, :level].each do |method|
        assert_true(Tumugi::Logger.instance.respond_to?(method))
      end
    end
  end

  sub_test_case '#config' do
    test 'returns Tumugi::Config instance' do
      assert_equal(Tumugi::Config, Tumugi.config.class)
    end

    test 'raise error when call #config with block' do
      assert_raise(Tumugi::ConfigError) do
        Tumugi.config do |c|
          c.workers = 2
          c.max_retry = 4
          c.retry_interval = 600
        end
      end
    end
  end

  sub_test_case '#configure' do
    test 'returns nil' do
      assert_nil(Tumugi.configure {})
    end

    test 'can change config values by block' do
      Tumugi.configure do |c|
        c.workers = 2
        c.max_retry = 4
        c.retry_interval = 600
      end

      assert_equal(2, Tumugi.config.workers)
      assert_equal(4, Tumugi.config.max_retry)
      assert_equal(600, Tumugi.config.retry_interval)
    end
  end
end
