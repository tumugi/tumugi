require_relative './test_helper'
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
    param :param_string
    param :param_string_with_default, default: 'default value'

    def initialize(requires: [], output: [])
      super()
      @requires = requires
      @output = output
    end

    def requires
      @requires
    end

    def output
      @output
    end

    def timeout
      5
    end
  end

  class TestSubTask < TestTask
    param :param_string_in_subclass, required: true
  end

  class TestSubSubTask < TestSubTask
    set :param_string_in_subclass, 'TestSubSubTask'
  end

  class TestSubSub2Task < TestSubTask
    set :param_string_in_subclass, 'TestSubSub2Task'
  end

  class TestSubSub3Task < TestSubTask
    set :param_string_in_subclass, ->{ @value += 1 }

    def initialize(value)
      super()
      @value = value
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

  sub_test_case '#param' do
    data(
      "param_string" => ["param_string", nil],
      "param_string_with_default" => ["param_string_with_default", "default value"],
    )
    test 'define implicit attribute accessor and assign deafult value if param has default value' do |(name, deafult_value)|
      task = TestTask.new
      assert_true(task.respond_to? name.to_sym)
      assert_true(task.respond_to? "#{name}=".to_sym)
      assert_equal(deafult_value, task.send(name.to_sym))
    end

    sub_test_case 'raise ParameterError when required parameter is not set' do
      test 'not set' do
        assert_raise(Tumugi::ParameterError) do
          TestSubTask.new
        end
      end

      test 'set nil' do
        klass = Class.new(TestSubTask)
        klass.set(:param_string_in_subclass, nil)
        assert_raise(Tumugi::ParameterError) do
          klass.new
        end
      end
    end

    test 'subclass can access and set parameter value by set' do
      task = TestSubSubTask.new
      assert_true(task.respond_to? "param_string_in_subclass".to_sym)
      assert_true(task.respond_to? "param_string_in_subclass=".to_sym)
      assert_equal('TestSubSubTask', task.param_string_in_subclass)

      # Check between subclasses are not affected each other
      task = TestSubSub2Task.new
      assert_true(task.respond_to? "param_string_in_subclass".to_sym)
      assert_true(task.respond_to? "param_string_in_subclass=".to_sym)
      assert_equal('TestSubSub2Task', task.param_string_in_subclass)
    end

    test 'set can accept Proc and evaluate it later and instance scope and cache results' do
      task = TestSubSub3Task.new(1)
      assert_equal(2, task.param_string_in_subclass)
      assert_equal(2, task.param_string_in_subclass)
    end

    sub_test_case 'raise ParameterError when parameter name cannot use' do
      test 'override instance method' do
        klass = Class.new(TestTask)
        assert_raise(Tumugi::ParameterError) do
          klass.param(:output, type: :string)
        end
      end

      test 'defined twice' do
        klass = Class.new(TestTask)
        assert_raise(Tumugi::ParameterError) do
          klass.param(:param1, type: :string)
          klass.param(:param1, type: :string)
        end
      end
    end
  end

  sub_test_case '#requires_failed' do
    test 'return true when requires task is failed' do
      requires_task = TestTask.new(output: NotExistOutput.new)
      requires_task.trigger!(:fail)
      task = TestTask.new(requires: requires_task)
      assert_true(task.requires_failed?)
    end

    test 'return false when requires task is completed' do
      requires_task = TestTask.new(output: NotExistOutput.new)
      requires_task.trigger!(:complete)
      task = TestTask.new(requires: requires_task)
      assert_false(task.requires_failed?)
    end
  end

  sub_test_case '#timeout' do
    test 'default value is nil' do
      assert_nil(Tumugi::Task.new.timeout)
    end

    test 'sub class can override timeout' do
      assert_equal(5, TestTask.new.timeout)
    end
  end

  sub_test_case 'state' do
    test 'initial state is pending' do
      assert_equal(:pending, @task.state)
    end
  end
end
