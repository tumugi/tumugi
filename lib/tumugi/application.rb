require 'optparse'
require 'tumugi/dag'

module Tumugi
  class Application
    def initialize
      @tasks = {}
    end

    def parse_options(argv = ARGV)
      op = OptionParser.new

      self.class.module_eval do
        define_method(:usage) do |msg = nil|
          puts op.to_s

          puts "error: #{msg}" if msg
          exit 1
        end
      end

      # default value
      opts = {
        boolean: false,
        string: '',
        integer: 0,
        array: [],
      }

      # boolean
      op.on('-b', '--[no-]boolean', "boolean value (default: #{opts[:boolean]})") {|v|
        opts[:boolean] = v
      }
      # string argument
      op.on('-s', '--string VALUE', "string value (default: #{opts[:string]})") {|v|
        opts[:string] = v
      }
      # array argument
      op.on('-a', '--array one,two,three', Array, "array value (default: #{opts[:array]})") {|v|
        opts[:array] = v
      }
      # optional integer argument (just cast)
      op.on('-i', '--integer [VALUE]', "integer value (default: #{opts[:integer]})") {|v|
        opts[:integer] = v.to_i
      }

      op.banner += ' tumugifile task'
      begin
        args = op.parse(argv)
      rescue OptionParser::InvalidOption => e
        usage e.message
      end

      if args.size < 2
        usage 'number of arguments is less than 2'
      end

      [opts, args]
    end

    def run
      opts, args = parse_options
      puts "opts: #{opts}"
      puts "args: #{args}"

      tumugifile = args[0]
      top_level_task = args[1]

      load tumugifile
      run_task top_level_task
    end

    def add_task(id, task)
      @tasks[id] = task
    end

    def find_task(id)
      @tasks[id]
    end

    private

    def run_task(id)
      dag = Tumugi::DAG.new
      t = @tasks[id.to_sym]
      dag.add_task(t)
      dag.tsort.each(&:run)
    end
  end
end
