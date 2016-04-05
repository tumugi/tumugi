require 'tumugi/task'

module Tumugi
  class TaskDefinition
    def self.define_task(id, opts={}, &block)
      td = Tumugi::TaskDefinition.new(id, opts)
      td.instance_eval(&block)
      Tumugi.application.add_task(id, td)
      td
    end

    attr_reader :required_tasks, :run_block

    def initialize(id, opts={})
      @id = id
      @opts = { type: Tumugi::Task }.merge(opts)
    end

    def instance
      return @task if @task

      @task = @opts[:type].new
      @task.id = @id
      td = self
      (class << @task; self; end).class_eval do
        define_method(:requires) do
          (td.required_tasks || []).map do |t|
            Tumugi.application.find_task(t)
          end
        end

        define_method(:output) do
          td.output_eval(self)
        end

        define_method(:run) do
          td.run_block.call(self)
        end
      end
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
      @run_block = block
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
  end
end
