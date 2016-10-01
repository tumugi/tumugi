require 'tumugi/dag'
require 'tumugi/dsl'
require 'tumugi/error'
require 'tumugi/plugin'
require 'tumugi/target'
require 'tumugi/command/run'
require 'tumugi/command/show'
require 'tumugi/mixin/human_readable'

require 'securerandom'

module Tumugi
  class Workflow
    include Tumugi::Mixin::HumanReadable

    attr_reader :id
    attr_accessor :params

    DEFAULT_CONFIG_FILE = "tumugi_config.rb"

    def initialize
      @id = SecureRandom.uuid
      @tasks = {}
      @params = {}
    end

    def execute(command, root_task_id, options)
      @start_time = Time.now
      logger.info "start id: #{id}"
      process_common_options(command, options)
      load_workflow_file(options[:file])
      dag = create_dag(root_task_id)
      command_module = Kernel.const_get("Tumugi").const_get("Command")
      cmd = command_module.const_get("#{command.to_s.capitalize}").new
      result = cmd.execute(dag, options)
      @end_time = Time.now
      logger.info "end id: #{id}, elapsed_time: #{elapsed_time}"
      result
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
        raise Tumugi::TumugiError, "Workflow file '#{file}' does not exist"
      end

      begin
        logger.info "Load workflow from #{file}"
        load(file, true)
      rescue Exception => e
        raise Tumugi::TumugiError.new("Workflow file load error: #{file}", e)
      end
    end

    def create_dag(id)
      dag = Tumugi::DAG.new
      task = find_task(id)
      dag.add_task(task)
      dag
    end

    def process_common_options(command, options)
      setup_logger(command, options)
      load_config(options)
      set_params(options)
    end

    def logger
      @logger ||= Tumugi::ScopedLogger.new("tumugi-workflow")
    end

    def setup_logger(command, options)
      log_format = (options[:log_format] || :text).to_sym
      if command == :run && !options[:out].nil?
        logger.init(output: options[:out], format: log_format)
      else
        logger.init(format: log_format)
      end
      logger.verbose! if options[:verbose]
      logger.quiet! if options[:quiet]
      logger.workflow_id = id
    end

    def load_config(options)
      config_file = options[:config]

      if config_file && !File.exist?(config_file)
        raise Tumugi::TumugiError, "Config file '#{config_file}' does not exist"
      end

      if !config_file && File.exist?(DEFAULT_CONFIG_FILE)
        config_file = DEFAULT_CONFIG_FILE
      end

      if config_file && File.exist?(config_file)
        logger.info "Load config from #{config_file}"
        begin
          load(config_file)
        rescue Exception => e
          raise Tumugi::TumugiError.new("Config file load error: #{config_file}", e)
        end
      end
    end

    def set_params(options)
      if options[:params]
        @params = options[:params]
        logger.info "Parameters: #{@params}"
      end
    end

    private

    def elapsed_time
      human_readable_time((@end_time - @start_time).to_i)
    end
  end
end
