require_relative '../test_helper'
require 'tumugi/dag'
require 'tumugi/task'
require 'tumugi/executor/local_executor'

class Tumugi::Executor::LocalExecutorTest < Test::Unit::TestCase
  class TestTask < Tumugi::Task
    def run
      sleep 2
    end
  end

  setup do
    @dag = Tumugi::DAG.new
    @task = TestTask.new
    @dag.add_task(@task)
  end

  teardown do
    Tumugi.configure do |config|
      config.timeout = nil
    end
  end

  sub_test_case '#execute' do
    test 'completed' do
      stub(@task).on_success
      dont_allow(@task).on_retry
      dont_allow(@task).on_failure

      executor = Tumugi::Executor::LocalExecutor.new(@dag)
      assert_true(executor.execute)
      assert_equal(:completed, @task.state)
      assert_received(@task) {|t| t.on_success }
    end

    test 'skipped' do
      def @task.completed?
        true
      end

      dont_allow(@task).on_success
      dont_allow(@task).on_retry
      dont_allow(@task).on_failure

      executor = Tumugi::Executor::LocalExecutor.new(@dag)
      assert_true(executor.execute)
      assert_equal(:skipped, @task.state)
    end

    test 'completed when task completed but run_all: true' do
      def @task.completed?
        true
      end

      stub(@task).on_success
      dont_allow(@task).on_retry
      dont_allow(@task).on_failure

      executor = Tumugi::Executor::LocalExecutor.new(@dag, run_all: true)
      assert_true(executor.execute)
      assert_equal(:completed, @task.state)
      assert_received(@task) {|t| t.on_success }
    end

    test 'faild' do
      Tumugi.configure do |config|
        config.max_retry = 2
        config.retry_interval = 1
      end
      @dag = Tumugi::DAG.new
      @task = TestTask.new
      @dag.add_task(@task)

      dont_allow(@task).on_success
      stub(@task).on_retry
      stub(@task).on_failure

      def @task.run
        raise 'always failed'
      end

      executor = Tumugi::Executor::LocalExecutor.new(@dag)
      assert_false(executor.execute)
      assert_equal(:failed, @task.state)
      assert_received(@task) {|t| t.on_retry.times(2) }
      assert_received(@task) {|t| t.on_failure }
    end

    test 'failed when task got timeout' do
      Tumugi.configure do |config|
        config.timeout = 1
      end
      @dag = Tumugi::DAG.new
      @task = TestTask.new
      @dag.add_task(@task)

      dont_allow(@task).on_success
      stub(@task).on_retry
      stub(@task).on_failure

      executor = Tumugi::Executor::LocalExecutor.new(@dag)
      assert_false(executor.execute)
      assert_equal(:failed, @task.state)
      assert_received(@task) {|t| t.on_retry.times(2) }
      assert_received(@task) {|t| t.on_failure }
    end
  end
end
