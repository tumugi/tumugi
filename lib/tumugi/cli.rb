require 'thor'
require 'tumugi'

module Tumugi
  class CLI < Thor
    package_name "tumugi"

    class << self
      def common_options
        option :file, aliases: '-f', desc: 'Task definition file name', required: true
        option :config, aliases: '-c', desc: 'Configuration file name', default: 'tumugi.rb'
      end
    end

    desc "version", "Show version"
    def version
      puts "tumugi v#{Tumugi::VERSION}"
    end

    desc "run TASK", "Run TASK in a workflow"
    map "run" => "run_" # run is thor's reserved word, so this trick is needed
    option :workers, aliases: '-w', type: :numeric, desc: 'Number of workers to run task concurrently'
    option :quiet, type: :boolean, desc: 'Suppress log', default: false
    option :verbose, type: :boolean, desc: 'Show verbose log', default: false
    common_options
    def run_(task)
      process_common_options
      Tumugi.application.execute(:run, task, options)
    end

    desc "show TASK", "Show DAG of TASK in a workflow"
    common_options
    option :out, aliases: '-o', desc: 'Output file name. If not specified, output result to STDOUT'
    option :format, aliases: '-t', desc: 'Output file format. Only affected --out option is specified.', enum: ['dot', 'png', 'svg']
    def show(task)
      process_common_options
      Tumugi.application.execute(:show, task, options)
    end

    private

    def process_common_options
      config_file = options[:config]
      if config_file && File.exists?(config_file) && File.extname(config_file) == '.rb'
        load(config_file)
      end
    end
  end
end
