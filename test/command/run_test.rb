require_relative '../test_helper'
require 'tumugi/dag'
require 'tumugi/task'
require 'tumugi/command/run'

class Tumugi::Command::RunTest < Test::Unit::TestCase
  class TestTask < Tumugi::Task
    def run
      sleep 2
    end
  end

  setup do
    @cmd = Tumugi::Command::Run.new
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
      @cmd.execute(@dag)
      assert_equal(:completed, @task.state)
    end

    test 'skipped' do
      def @task.completed?
        true
      end

      @cmd.execute(@dag)
      assert_equal(:skipped, @task.state)
    end

    test 'faild' do
      Tumugi.configure do |config|
        config.max_retry = 2
        config.retry_interval = 1
      end
      @dag = Tumugi::DAG.new
      @task = TestTask.new
      @dag.add_task(@task)

      def @task.run
        raise 'always failed'
      end

      success = @cmd.execute(@dag)
      assert_false(success)
      assert_equal(:failed, @task.state)
    end

    test 'failed when task got timeout' do
      Tumugi.configure do |config|
        config.timeout = 1
      end
      @dag = Tumugi::DAG.new
      @task = TestTask.new
      @dag.add_task(@task)

      success = @cmd.execute(@dag)
      assert_false(success)
      assert_equal(:failed, @task.state)
    end
  end
end
