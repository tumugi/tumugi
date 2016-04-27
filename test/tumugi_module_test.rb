require 'test_helper'
require 'tumugi/tumugi_module'

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
end
