require 'thor'
require 'tumugi'
require 'tumugi/tumugi_module'

module Tumugi
  class CLI < Thor
    package_name "tumugi"

    desc "version", "Show version"
    def version
      puts "tumugi v#{Tumugi::VERSION}"
    end

    desc "run", "Run workflow"
    option :file, default: 'tumugifile', aliases: [:f]
    map "run" => "run_" # run is thor's reserved word, so this trick is needed
    def run_(file, task)
      Tumugi.application.execute(:run, file, task, options)
    end

    desc "show", "Show DAG of workflow"
    option :file, default: 'tumugifile', aliases: [:f]
    def show(file, task)
      Tumugi.application.execute(:show, file, task, options)
    end
  end
end
