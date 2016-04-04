require 'tumugi/task'

module Tumugi
  class TaskDefinition
    attr_reader :required_tasks, :run_block

    def self.define_task(id, opts={})
      td = Tumugi::TaskDefinition.new(id, opts)
      yield td if block_given?
      Tumugi.application.add_task(id, td)
      td
    end

    def initialize(id, opts={})
      @id = id
      @opts = { type: Tumugi::Task }.merge(opts)
    end

    def create_task
      task = @opts[:type].new
      task.id = @id
      td = self
      (class << task; self; end).class_eval do
        define_method(:requires) do
          (td.required_tasks || []).map do |t|
            Tumugi.application.find_task(t)
          end
        end

        define_method(:run) do
          td.run_block.call
        end
      end
      task
    end

    def requires(tasks)
      @required_tasks = tasks
    end

    def run(&block)
      @run_block = block
    end
  end
end
