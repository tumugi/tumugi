require_relative './test_helper'
require 'tumugi/task_definition'

class Tumugi::TaskDefinitionTest < Test::Unit::TestCase
  setup do
    @task_def = Tumugi::TaskDefinition.new(:test, a: 'b')
  end

  sub_test_case 'initialize' do
    test 'id' do
      assert_equal(:test, @task_def.id)
    end

    sub_test_case 'opts' do
      test 'type is class' do
        assert_equal(2, @task_def.opts.size)
        assert_equal(Tumugi::Task, @task_def.opts[:type])
        assert_equal('b', @task_def.opts[:a])
      end

      test 'type is plugin ID' do
        class TestTask < Tumugi::Task
          Tumugi::Plugin.register_task(:test, self)
        end
        @task_def = Tumugi::TaskDefinition.new(:test, type: :test)
        assert_equal(TestTask, @task_def.opts[:type])
      end
    end
  end

  sub_test_case '#instance' do
    test 'returns Tumugi::Task instance' do
      task = @task_def.instance
      assert_equal(:test, task.id)
      assert_true(task.is_a?(Tumugi::Task))
    end

    test 'returns instance of specified by class' do
      class Task1 < Tumugi::Task; end
      @task_def = Tumugi::TaskDefinition.new(:test, type: Task1)
      task = @task_def.instance
      assert_equal(:test, task.id)
      assert_true(task.is_a?(Task1))
    end

    test 'returns instance of specified by plugin ID' do
      class Task1 < Tumugi::Task
        Tumugi::Plugin.register_task(:task1, self)
      end
      @task_def = Tumugi::TaskDefinition.new(:test, type: :task1)
      task = @task_def.instance
      assert_equal(:test, task.id)
      assert_true(task.is_a?(Task1))
    end

    test 'raise error if type is not a subclass of Tumugi::Task' do
      assert_raise do
        @task_def = Tumugi::TaskDefinition.new(:test, type: String)
        @task_def.instance
      end
    end

    test 'returns same instance after first call' do
      task = @task_def.instance
      assert_same(task, @task_def.instance)
    end

    sub_test_case 'task#requires' do
      test 'nil' do
        task = @task_def.instance
        stub(@task_def).required_tasks { nil }
        assert_equal([], task.requires)
      end

      test 'Array' do
        task = @task_def.instance
        t1 = Tumugi::Task.new
        t2 = Tumugi::Task.new
        stub(Tumugi.application).find_task(:a) { t1 }
        stub(Tumugi.application).find_task(:b) { t2 }
        stub(@task_def).required_tasks { [:a, :b] }
        assert_equal([t1, t2], task.requires)
      end

      test 'Hash' do
        task = @task_def.instance
        t1 = Tumugi::Task.new
        t2 = Tumugi::Task.new
        stub(Tumugi.application).find_task(:a) { t1 }
        stub(Tumugi.application).find_task(:b) { t2 }
        stub(@task_def).required_tasks { { a: :a, b: :b } }
        assert_equal({ a: t1, b: t2 }, task.requires)
      end

      test 'Tumugi::Task' do
        task = @task_def.instance
        t1 = Tumugi::Task.new
        stub(Tumugi.application).find_task(:a) { t1 }
        stub(@task_def).required_tasks { :a }
        assert_equal(t1, task.requires)
      end
    end

    sub_test_case 'task#output' do
      test 'eval provided value' do
        @task_def.output([:a, :b])
        task = @task_def.instance
        assert_equal([:a, :b], task.output)
      end

      test 'call method of superclass when block is not provided' do
        task = @task_def.instance
        assert_equal([], task.output)
      end
    end

    sub_test_case 'task#run' do
      test 'call provided block' do
        @task_def.run {|t| t.id}
        task = @task_def.instance
        stub(@task_def).run_block(task) { }
        task.run
        assert_received(@task_def) {|t| t.run_block(task)}
      end

      test 'call method of superclass when block is not provided' do
        task = @task_def.instance
        assert_raise(NotImplementedError) do
          task.run
        end
      end
    end

    sub_test_case 'parameters' do
      test 'param should add param and assign default value' do
        @task_def.param(:key1, default: 'value1')
        @task_def.run {|t| t.key1}
        task = @task_def.instance
        assert_true(task.respond_to?(:key1))
        assert_equal('value1', task.key1)
      end

      test 'param_set should assign default value' do
        @task_def.param(:key1)
        @task_def.param_set(:key1, 'value1')
        @task_def.run {|t| t.key1}
        task = @task_def.instance
        assert_true(task.respond_to?(:key1))
        assert_equal('value1', task.key1)
      end
    end
  end

  test '#required_tasks returns value which set by #requires' do
    @task_def.requires([:a, :b])
    assert_equal([:a, :b], @task_def.required_tasks)
  end

  test '#run_block run Proc which set by #run' do
    task = Tumugi::Task.new
    stub(task).id { :id }
    @task_def.run do |t|
      t.id
    end
    @task_def.run_block(task)
    assert_received(task) {|t| t.id}
  end

  sub_test_case '#output_eval' do
    setup do
      @task = Tumugi::Task.new
    end

    test 'return object which is set by #output' do
      @task_def.output([:a, :b])
      assert_equal([:a, :b], @task_def.output_eval(@task))
    end

    test 'return result of eval when object which is set by #output is block' do
      stub(@task).id { :id }
      @task_def.output do |task|
        task.id
      end
      @task_def.output_eval(@task)
      assert_received(@task) {|t| t.id}
    end
  end
end
