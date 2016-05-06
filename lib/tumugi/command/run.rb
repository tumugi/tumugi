require 'parallel'
require 'retriable'
require 'terminal-table'
require 'tumugi/mixin/listable'

module Tumugi
  module Command
    class Run
      include Tumugi::Mixin::Listable

      def execute(dag, options={})
        workers = options[:workers] || Tumugi.config.workers
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

            begin
              Retriable.retriable retry_options do
                t.run
              end
            rescue => e
              Tumugi.logger.info "failed: #{t.id}"
              Tumugi.logger.error "#{e.message}"
              t.state = :failed
            else
              Tumugi.logger.info "completed: #{t.id}"
              t.state = :completed
            end
          else
            t.state = :skipped
            Tumugi.logger.info "skip: #{t.id} is already completed"
          end
        end

        show_result_report(dag)
      end

      private

      def retry_options
        {
          tries: Tumugi.config.max_retry,
          base_interval: Tumugi.config.retry_interval,
          max_interval: Tumugi.config.retry_interval * Tumugi.config.max_retry,
          max_elapsed_time: Tumugi.config.retry_interval * Tumugi.config.max_retry,
          multiplier: 1.0,
          rand_factor: 0.0,
          on_retry: on_retry
        }
      end

      def on_retry
        Proc.new do |exception, try, elapsed_time, next_interval|
          Tumugi.logger.error "#{exception.class}: '#{exception.message}' - #{try} tries in #{elapsed_time} seconds and #{next_interval} seconds until the next try."
        end
      end

      def show_result_report(dag)
        headings = ['Task', 'Requires', 'Parameters', 'State']
        table = Terminal::Table.new headings: headings do |t|
          dag.tsort.reverse.map do |task|
            proxy = task.class.merged_parameter_proxy
            requires = list(task.requires).map do |r|
              r.id
            end
            params = proxy.params.map do |name, _|
              "#{name}=#{task.instance_variable_get("@#{name}")}"
            end
            t << [ task.id, requires.join("\n"), params.join("\n"), task.state ]
          end
        end
        Tumugi.logger.info "Result report:\n#{table.to_s}"
      end
    end
  end
end
