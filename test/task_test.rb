require 'test_helper'
require 'tumugi/task'
require 'tumugi/target'

class Tumugi::TaskTest < Test::Unit::TestCase
  class ExistOutput < Tumugi::Target
    def exist?; true end
  end

  class NotExistOutput < Tumugi::Target
    def exist?; false end
  end

  class TestTask < Tumugi::Task
    def initialize(requires: [], output: [])
      @requires = requires
      @output = output
    end

    def requires
      @requires
    end

    def output
      @output
    end
  end

  setup do
    @task = Tumugi::Task.new
  end

  sub_test_case 'id' do
    test 'initialized by class name' do
      assert_equal('Tumugi::Task', @task.id)
    end

    test 'can modify' do
      id = 'test'
      @task.id = id
      assert_equal(id, @task.id)
    end
  end

  sub_test_case '#eql?' do
    test 'returns true when task has same id' do
      id = 'test'
      other = Tumugi::Task.new
      @task.id = other.id = id
      assert_true(@task.eql?(other))
    end

    test 'returns true when task has different id' do
      other = Tumugi::Task.new
      @task.id = 'test1'
      other.id = 'test2'
      assert_false(@task.eql?(other))
    end
  end

  test '#instance returns self' do
    assert_same(@task, @task.instance)
  end

  test '#hash returns hash of id' do
    id = 'test'
    @task.id = id
    assert_equal(id.hash, @task.hash)
  end

  test '#requires returns empty array' do
    assert_equal([], @task.requires)
  end

  test '#output returns empty array' do
    assert_equal([], @task.output)
  end

  test '#run raise NotImplementedError' do
    assert_raise(NotImplementedError) do
      @task.run
    end
  end

  sub_test_case '#input' do
    test 'returns empty array as default value' do
      assert_equal([], @task.input)
    end

    test 'returns empty array when task#requires is nil' do
      assert_equal([], TestTask.new(requires: nil).input)
    end

    test 'returns array of task#output when task#requires is array' do
      tasks = [
        TestTask.new(output: ExistOutput.new),
        TestTask.new(output: NotExistOutput.new)
      ]
      result = TestTask.new(requires: tasks).input
      assert_true(result.is_a?(Array))
      assert_equal(2, result.size)
      assert_equal(ExistOutput, result[0].class)
      assert_equal(NotExistOutput, result[1].class)
    end

    test 'returns hash of task#output when task#requires is array' do
      tasks = {
        task1: TestTask.new(output: ExistOutput.new),
        task2: TestTask.new(output: NotExistOutput.new)
      }
      result = TestTask.new(requires: tasks).input
      assert_true(result.is_a?(Hash))
      assert_equal(2, result.size)
      assert_equal(ExistOutput, result[:task1].class)
      assert_equal(NotExistOutput, result[:task2].class)
    end

    test 'returns task#output when task#requires is single task' do
      task = TestTask.new(output: ExistOutput.new)
      result = TestTask.new(requires: task).input
      assert_equal(ExistOutput, result.class)
    end
  end

  sub_test_case '#ready?' do
    test 'return true when all required tasks are completed' do
      task = TestTask.new(requires: TestTask.new(output: ExistOutput.new))
      assert_true(task.ready?)
    end

    test 'return false when required tasks are not completed' do
      task = TestTask.new(requires: TestTask.new(output: NotExistOutput.new))
      assert_false(task.ready?)
    end
  end

  sub_test_case '#completed?' do
    test 'return false as default value' do
      assert_false(@task.completed?)
    end

    test 'return true when all outputs are exists' do
      assert_true(TestTask.new(output: ExistOutput.new).completed?)
    end
  end
end
