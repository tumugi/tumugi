require 'tumugi/dag'
require 'tumugi/dsl'
require 'tumugi/plugin'
require 'tumugi/target'
require 'tumugi/command/run'
require 'tumugi/command/show'

module Tumugi
  class Application
    def initialize
      @tasks = {}
    end

    def execute(command, root_task_id, options)
      load(options[:file], true)
      dag = create_dag(root_task_id)
      command_module = Kernel.const_get("Tumugi").const_get("Command")
      cmd = command_module.const_get("#{command.to_s.capitalize}").new
      cmd.execute(dag, options)
    end

    def add_task(id, task)
      @tasks[id.to_s] = task
    end

    def find_task(id)
      task = @tasks[id.to_s]
      raise "Task not found: #{id}" if task.nil?
      task
    end

    private

    def create_dag(id)
      dag = Tumugi::DAG.new
      task = find_task(id)
      dag.add_task(task)
      dag
    end
  end
end
