require 'tumugi/task'

module Tumugi
  class TaskDefinition
    include Tumugi::Helper

    def self.define(id, opts={}, &block)
      td = Tumugi::TaskDefinition.new(id, opts)
      td.instance_eval(&block)
      Tumugi.application.add_task(id, td)
      td
    end

    attr_reader :id, :opts

    def initialize(id, opts={})
      @id = id
      @opts = { type: Tumugi::Task }.merge(opts)
    end

    def instance
      @task ||= create_task
    end

    def requires(tasks)
      @required_tasks = tasks
    end

    def output(outputs=[], &block)
      @outputs ||= (block || outputs)
    end

    def run(&block)
      @run = block
    end

    def output_eval(task)
      @out ||= @outputs.is_a?(Proc) ? @outputs.call(task) : @outputs
    end

    def required_tasks
      @required_tasks
    end

    def run_block(task)
      @run.call(task)
    end

    private

    def create_task
      task = define_task.new
      task.id = @id
      task
    end

    def define_task
      task_class = Class.new(@opts[:type])
      define_requires_method(task_class)
      define_output_method(task_class)
      define_run_method(task_class)
      task_class
    end

    def define_requires_method(task_class)
      td = self
      task_class.class_eval do
        define_method(:requires) do
          reqs = td.required_tasks
          if reqs.nil?
            []
          elsif reqs.is_a?(Array)
            reqs.map { |t| Tumugi.application.find_task(t) }
          elsif reqs.is_a?(Hash)
            Hash[reqs.map { |k, t| [k, Tumugi.application.find_task(t)] }]
          else
            Tumugi.application.find_task(reqs)
          end
        end
      end
    end

    def define_output_method(task_class)
      td = self
      task_class.class_eval do
        define_method(:output) do
          td.output_eval(self)
        end
      end unless @outputs.nil?
    end

    def define_run_method(task_class)
      td = self
      task_class.class_eval do
        define_method(:run) do
          td.run_block(self)
        end
      end unless @run.nil?
    end
  end
end
