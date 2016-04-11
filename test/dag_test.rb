require 'test_helper'

class Tumugi::DAGTest < Test::Unit::TestCase
  setup do
    @dag = Tumugi::DAG.new
  end

  test '#initialize' do
    assert_equal([], @dag.tsort)
  end

  sub_test_case '#add_task' do
    class Task1 < Tumugi::Task
    end

    class Task2 < Tumugi::Task
      def requires
        Task1.new
      end
    end

    class TaskA < Tumugi::Task
      def requires
        [ TaskB.new, TaskC.new ]
      end
    end

    class TaskB < Tumugi::Task
      def requires
        Task1.new
      end
    end

    class TaskC < Tumugi::Task
      def requires
        Task1.new
      end
    end

    test 'single task' do
      task = Task1.new
      @dag.add_task(task)
      result = @dag.tsort
      assert_equal([task], result)
    end

    test 'simple task chain' do
      task = Task2.new
      @dag.add_task(task)
      result = @dag.tsort
      assert_equal(2, result.size)
      assert_equal(Task1, result[0].class)
      assert_equal(Task2, result[1].class)
    end

    test 'diamond task chain' do
      task = TaskA.new
      @dag.add_task(task)
      result = @dag.tsort
      assert_equal(4, result.size)
      assert_equal(Task1, result[0].class)
      assert_equal(TaskB, result[1].class)
      assert_equal(TaskC, result[2].class)
      assert_equal(TaskA, result[3].class)
    end
  end
end
