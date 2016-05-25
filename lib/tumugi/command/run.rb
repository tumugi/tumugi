require 'parallel'
require 'retriable'
require 'terminal-table'
require 'thor'
require 'timeout'

require 'tumugi/error'
require 'tumugi/mixin/listable'

module Tumugi
  module Command
    class Run
      include Tumugi::Mixin::Listable

      def execute(dag, options={})
        workers = options[:workers] || Tumugi.config.workers
        settings = { in_threads: workers }
        logger = Tumugi.logger

        Parallel.each(dag.tsort, settings) do |t|
          logger.info "start: #{t.id}"
          timeout = t.timeout || Tumugi.config.timeout
          Timeout::timeout(timeout, Tumugi::TimeoutError) do
            until t.ready? || t.requires_failed?
              sleep 1
            end

            if t.completed?
              t.state = :skipped
              logger.info "#{t.state}: #{t.id} is already completed"
            elsif t.requires_failed?
              t.state = :requires_failed
              logger.info "#{t.state}: #{t.id} has failed requires task"
            else
              logger.info "run: #{t.id}"
              t.state = :running

              begin
                Retriable.retriable retry_options do
                  t.run
                end
              rescue => e
                t.state = :failed
                logger.info "#{t.state}: #{t.id}"
                logger.error "#{e.message}"
                logger.error e.backtrace.join("\n")
              else
                t.state = :completed
                logger.info "#{t.state}: #{t.id}"
              end
            end
          end
        end

        show_result_report(dag)
        return !dag.tsort.any? { |t| t.state == :failed }
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
          if next_interval
            Tumugi.logger.error "#{exception.class}: '#{exception.message}' - #{try} tries in #{elapsed_time} seconds and #{next_interval} seconds until the next try."
          else
            Tumugi.logger.error "#{exception.class}: '#{exception.message}' - #{try} tries in #{elapsed_time} seconds. Task failed."
          end
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
              "#{name}=#{task.send(name.to_sym)}"
            end
            t << [ task.id, requires.join("\n"), params.join("\n"), task.state ]
          end
        end
        Tumugi.logger.info "Result report:\n#{table.to_s}"
      end
    end
  end
end
