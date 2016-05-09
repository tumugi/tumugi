require 'tumugi/dag'
require 'tumugi/dsl'
require 'tumugi/error'
require 'tumugi/plugin'
require 'tumugi/target'
require 'tumugi/command/run'
require 'tumugi/command/show'

module Tumugi
  class Application
    attr_accessor :params

    def initialize
      @tasks = {}
      @params = {}
    end

    def execute(command, root_task_id, options)
      process_common_options(options)
      load_workflow_file(options[:file])
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
      raise Tumugi::TumugiError, "Task not found: #{id}" if task.nil?
      task
    end

    private

    def load_workflow_file(file)
      unless File.exist?(file)
        raise Tumugi::TumugiError, "Workflow file '#{file}' not exist."
      end

      begin
        load(file, true)
      rescue LoadError => e
        raise Tumugi::TumugiError, e.message
      end
    end

    def create_dag(id)
      dag = Tumugi::DAG.new
      task = find_task(id)
      dag.add_task(task)
      dag
    end

    def process_common_options(options)
      setup_logger(options)
      load_config(options)
      set_params(options)
    end

    def logger
      @logger ||= Tumugi.logger
    end

    def setup_logger(options)
      logger.verbose! if options[:verbose]
      logger.quiet! if options[:quiet]
    end

    def load_config(options)
      config_file = options[:config]
      if config_file && File.exists?(config_file) && File.extname(config_file) == '.rb'
        logger.info "Load config from #{config_file}"
        load(config_file)
      end
    rescue LoadError => e
      raise Tumugi::TumugiError, e.message
    end

    def set_params(options)
      if options[:params]
        @params = options[:params]
        logger.info "Parameters: #{@params}"
      end
    end
  end
end
