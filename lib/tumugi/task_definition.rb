require 'tumugi/task'

module Tumugi
  class TaskDefinition
    include Tumugi::Helper

    def self.define_task(id, opts={}, &block)
      td = Tumugi::TaskDefinition.new(id, opts)
      td.instance_eval(&block)
      Tumugi.application.add_task(id, td)
      td
    end

    def initialize(id, opts={})
      @id = id
      @opts = { type: Tumugi::Task }.merge(opts)
    end

    def instance
      return @task if @task

      td = self
      base_class = @opts[:type]
      task_class = Class.new(base_class) do
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

        define_method(:output) do
          td.output_eval(self)
        end

        define_method(:run) do
          td.run_block(self)
        end
      end

      @task = task_class.new
      @task.id = @id
      @task
    end

    def requires(tasks)
      @required_tasks = tasks
    end

    def output(outputs=[], &block)
      if block_given?
        @outputs = block
      else
        @outputs = outputs
      end
    end

    def run(&block)
      @run = block
    end

    def output_eval(task)
      return @out if @out

      if @outputs.is_a?(Proc)
        @out = @outputs.call(task)
      else
        @out = @outputs
      end
      @out
    end

    def required_tasks
      @required_tasks
    end

    def run_block(task)
      @run.call(task)
    end
  end
end
