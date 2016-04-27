require 'thor'
require 'tumugi'
require 'tumugi/tumugi_module'

module Tumugi
  class CLI < Thor
    package_name "tumugi"

    class << self
      def common_options
        option :file, aliases: '-f', desc: 'Task definition file name', default: 'tumugifile'
      end
    end

    desc "version", "Show version"
    def version
      puts "tumugi v#{Tumugi::VERSION}"
    end

    desc "run", "Run workflow"
    map "run" => "run_" # run is thor's reserved word, so this trick is needed
    option :workers, aliases: '-w', type: :numeric, desc: 'Number of workers to run task concurrently', default: 1
    option :quiet, type: :boolean, desc: 'Suppress log', default: false
    option :verbose, type: :boolean, desc: 'Show verbose log', default: false
    common_options
    def run_(task)
      Tumugi.application.execute(:run, task, options)
    end

    desc "show", "Show DAG of workflow"
    common_options
    option :out, aliases: '-o', desc: 'Output file name. If not specified, output result to STDOUT'
    option :format, aliases: '-t', desc: 'Output file format. Only affected --out option is specified.', enum: ['dot', 'png', 'svg']
    def show(task)
      Tumugi.application.execute(:show, task, options)
    end
  end
end
