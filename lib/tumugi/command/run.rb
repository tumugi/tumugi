require 'parallel'

module Tumugi
  module Command
    class Run
      def execute(dag, options)
        workers = options[:workers] || 1
        worker_type = options[:worker_type] || 'process'
        settings = {}
        case worker_type
        when 'process' then settings[:in_processes] = workers
        when 'thread'  then settings[:in_threads] = workers
        end

        logger = Logger.new(STDOUT)
        logger.level = Logger::INFO unless options[:verbose]
        if options[:quiet]
          logger = Logger.new(nil)
        end

        Parallel.each(dag.tsort, settings) do |t|
          t.logger = logger
          logger.info "start: #{t.id}"
          until t.ready?
            sleep 1
          end
          unless t.completed?
            logger.info "run: #{t.id}"
            t.state = :running
            t.run
            t.state = :completed
          else
            t.state = :skipped
            logger.info "skip: #{t.id} is already completed"
          end
        end
      end
    end
  end
end
