require_relative '../test_helper'
require 'tumugi/dag'
require 'tumugi/task'
require 'tumugi/command/run'

class Tumugi::Command::RunTest < Test::Unit::TestCase
  class TestTask < Tumugi::Task
    def run; end
  end

  setup do
    @cmd = Tumugi::Command::Run.new
    @dag = Tumugi::DAG.new
    @task = TestTask.new
    @dag.add_task(@task)
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
      def @task.run
        raise 'always failed'
      end
      Tumugi.config do |c|
        c.max_retry = 2
        c.retry_interval = 1
      end

      success = @cmd.execute(@dag)
      assert_false(success)
      assert_equal(:failed, @task.state)
    end
  end
end
