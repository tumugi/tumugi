require 'test_helper'

class Tumugi::TumugiModuleTest < Test::Unit::TestCase
  sub_test_case '#application' do
    test 'returns Tumugi::Application instance' do
      assert_equal(Tumugi::Application, Tumugi.application.class)
    end

    test 'returns same instance when called multiple' do
      assert_same(Tumugi.application, Tumugi.application)
    end
  end

  sub_test_case '#logger' do
    test 'returns Tumugi::Logger instance' do
      assert_equal(Tumugi::Logger, Tumugi.logger.class)
    end

    test 'returns same instance when called multiple' do
      assert_same(Tumugi.logger, Tumugi.logger)
    end

    test 'should respond to delegated methods' do
      [:debug, :error, :fatal, :info, :warn, :level].each do |method|
        assert_true(Tumugi.logger.respond_to?(method))
      end
    end
  end

  sub_test_case '#config' do
    test 'returns Tumugi::Logger instance' do
      assert_equal(Tumugi::Config, Tumugi.config.class)
    end

    test 'returns same instance when called multiple' do
      assert_same(Tumugi.config, Tumugi.config)
    end

    test 'can change config values by block' do
      Tumugi.config do |c|
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
