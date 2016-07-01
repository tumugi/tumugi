require_relative './test_helper'
require 'tumugi/workflow'

class Tumugi::WorkflowTest < Test::Unit::TestCase
  setup do
    @workflow = Tumugi::Workflow.new
  end

  test '#initialize' do
    assert_not_nil(@workflow.id)
  end

  sub_test_case '#setup_logger' do
    test 'default log level is INFO' do
      @workflow.send(:setup_logger, :run, {})
      assert_equal(Logger::INFO, Tumugi::Logger.instance.level)
    end

    test 'log level is DEBUG when verbose flag is true' do
      @workflow.send(:setup_logger, :run, verbose: true)
      assert_equal(Logger::DEBUG, Tumugi::Logger.instance.level)
    end

    test 'log is disabled when quiet flag is true' do
      @workflow.send(:setup_logger, :run, quiet: true)
      result = capture_stdout { Tumugi::Logger.instance.info 'test' }
      assert_equal('', result)
    end
  end
end
