require 'thor'
require 'tumugi'
require 'tumugi/command/new'

module Tumugi
  class CLI < Thor
    package_name "tumugi"
    default_command "run_"

    class << self
      def common_options
        option :file, aliases: '-f', desc: 'Workflow file name', required: true
        option :config, aliases: '-c', desc: 'Configuration file name'
        option :params, aliases: '-p', type: :hash, desc: 'Task parameters'
        option :quiet, type: :boolean, desc: 'Suppress log', default: false
        option :verbose, type: :boolean, desc: 'Show verbose log', default: false
        option :log_format, type: :string, desc: 'Log format', enum: ['text', 'json'], default: 'text'
      end

      def exit_on_failure?
        true
      end
    end

    desc "version", "Show version"
    def version
      puts "tumugi v#{Tumugi::VERSION}"
    end

    desc "run TASK", "Run TASK in a workflow"
    map "run" => "run_" # run is thor's reserved word, so this trick is needed
    option :workers, aliases: '-w', type: :numeric, desc: 'Number of workers to run task concurrently'
    option :out, aliases: '-o', desc: 'Output log filename. If not specified, log is write to STDOUT'
    option :all, aliases: '-a', type: :boolean, desc: 'Run all tasks even if target exists', default: false
    common_options
    def run_(task)
      execute(:run, task, options)
    end

    desc "show TASK", "Show DAG of TASK in a workflow"
    common_options
    option :out, aliases: '-o', desc: 'Output file name. If not specified, output result to STDOUT'
    option :format, aliases: '-t', desc: 'Output file format. Only affected --out option is specified.', enum: ['dot', 'png', 'svg']
    def show(task)
      opts = options.dup
      opts[:quiet] = true if opts[:out].nil?
      execute(:show, task, opts.freeze)
    end

    desc "new type NAME", "Create a new template of type. type is 'plugin' or 'project'"
    def new(type, name)
      generate_project(type, name, options)
    end

    desc "init", "Create an tumugi project template"
    def init(path='')
      generate_project('project', path, force: true)
    end

    private

    def execute(command, task, options)
      logger.info "tumugi v#{Tumugi::VERSION}"
      args = { task: task, options: options }
      logger.info "status: running, command: #{command}, args: #{args}"
      success = Tumugi.workflow.execute(command, task, options)
      unless success
        raise Thor::Error, "execute finished, but failed"
      end
      logger.info "status: success, command: #{command}, args: #{args}"
    rescue => e
      handle_error(command, e, args)
    end

    def generate_project(type, name, options)
      logger.info "tumugi v#{Tumugi::VERSION}"
      args = { type: type, name: name, options: options }
      logger.info "status: running, command: new, args: #{args}"
      Tumugi::Command::New.new.execute(type, name, options)
      logger.info "status: success, command: new, args: #{args}"
    rescue => e
      handle_error("new", e, args)
    end

    private

    def handle_error(command, e, args)
      logger.error "#{command} command failed"
      logger.error e.message
      reason = e
      if e.is_a?(Tumugi::TumugiError) && !e.reason.nil?
        reason = e.reason
        logger.error reason.message
      end
      if options[:verbose]
        logger.error { reason.backtrace.join("\n") }
      else
        logger.error "If you want to know more detail, run with '--verbose' option"
      end
      logger.error "status: failed, command: #{command}, args: #{args}"
      raise Thor::Error.new("tumugi #{command} failed, please check log")
    end

    def logger
      @logger ||= Tumugi::ScopedLogger.new("tumugi-main")
    end
  end
end
