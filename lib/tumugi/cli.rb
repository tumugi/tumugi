require 'thor'
require 'tumugi'
require 'tumugi/command/new'

module Tumugi
  class CLI < Thor
    package_name "tumugi"

    class << self
      def common_options
        option :file, aliases: '-f', desc: 'Workflow file name', required: true
        option :config, aliases: '-c', desc: 'Configuration file name', default: 'tumugi_config.rb'
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

    desc "new PLUGIN_NAME", "Create new plugin project"
    def new(name)
      generate_plugin(name, options)
    end

    private

    def execute(command, task, options)
      success = Tumugi.application.execute(command, task, options)
      unless success
        raise Thor::Error, "execute finished, but return it's failed"
      end
      logger.info "status: success, command: #{command}, task: #{task}, options: #{options}"
    rescue => e
      logger.error "#{command} command failed"
      logger.error e.message
      logger.error "If you want to know more detail, run with '--vebose' option"
      e.backtrace.each { |line| logger.debug line }
      logger.error "status: failed, command: #{command}, task: #{task}, options: #{options}"
      raise Thor::Error.new("tumugi #{command} failed, please check log")
    end

    def generate_plugin(name, options)
      Tumugi::Command::New.new.execute(name, options)
      logger.info "status: success, command: new, name: #{name}, options: #{options}"
    rescue => e
      logger.error e.message
      logger.error "If you want to know more detail, run with '--vebose' option"
      e.backtrace.each { |line| logger.debug line }
      logger.error "status: failed, command: new, name: #{name}, options: #{options}"
      raise Thor::Error.new("tumugi new failed, please check log")
    end

    def logger
      Tumugi::Logger.instance
    end
  end
end
