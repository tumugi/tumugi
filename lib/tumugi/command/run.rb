require 'parallel'

module Tumugi
  module Command
    class Run
      def execute(dag, options={})
        workers = options[:workers] || 1
        settings = { in_threads: workers }

        Tumugi.logger.verbose! if options[:verbose]
        Tumugi.logger.quiet! if options[:quiet]

        Parallel.each(dag.tsort, settings) do |t|
          Tumugi.logger.info "start: #{t.id}"
          until t.ready?
            sleep 1
          end
          unless t.completed?
            Tumugi.logger.info "run: #{t.id}"
            t.state = :running
            t.run
            t.state = :completed
          else
            t.state = :skipped
            Tumugi.logger.info "skip: #{t.id} is already completed"
          end
        end
      end
    end
  end
end
