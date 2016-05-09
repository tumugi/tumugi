require 'thor'
require 'tumugi'

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
    common_options
    def run_(task)
      execute(:run, task, options)
    end

    desc "show TASK", "Show DAG of TASK in a workflow"
    common_options
    option :out, aliases: '-o', desc: 'Output file name. If not specified, output result to STDOUT'
    option :format, aliases: '-t', desc: 'Output file format. Only affected --out option is specified.', enum: ['dot', 'png', 'svg']
    def show(task)
      execute(:show, task, options)
    end

    private

    def execute(command, task, options)
      success = Tumugi.application.execute(command, task, options)
      unless success
        Tumugi.logger.error "#{command} command failed"
        raise Thor::Error, 'failed'
      end
    rescue => e
      Tumugi.logger.error "#{command} command failed"
      Tumugi.logger.error e.message
      e.backtrace.each { |line| Tumugi.logger.error line }
      raise Thor::Error, 'failed'
    end
  end
end
