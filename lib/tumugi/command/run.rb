require 'much-timeout'
require 'parallel'
require 'retriable'
require 'thor'

require 'tumugi/error'
require 'tumugi/dag_result_reporter'

module Tumugi
  module Command
    class Run
      def execute(dag, options={})
        workers = options[:workers] || Tumugi.config.workers
        settings = { in_threads: workers }
        start(dag, settings)
        show_result_report(dag)
        !dag.tsort.any? { |t| t.state == :failed }
      end

      private

      def start(dag, settings)
        logger.info "start job: #{Tumugi.application.job.id}"

        setup_task_queue(dag)
        Parallel.each(dequeue_task, settings) do |t|
          if t.requires_failed?
            t.state = :requires_failed
            logger.info "#{t.state}: #{t.id} has failed requires task"
            next
          end

          if !t.ready?
            enqueu_task(t)
            next
          end

          MuchTimeout.optional_timeout(task_timeout(t), Tumugi::TimeoutError) do
            logger.info "start: #{t.id}"
            if t.completed?
              t.state = :skipped
              logger.info "#{t.state}: #{t.id} is already completed"
            else
              logger.info "run: #{t.id}"
              t.state = :running

              begin
                Retriable.retriable retry_options do
                  t.run
                end
                t.state = :completed
                logger.info "#{t.state}: #{t.id}"
              rescue => e
                t.state = :failed
                logger.info "#{t.state}: #{t.id}"
                logger.error "#{e.message}"
                logger.error e.backtrace.join("\n")
              end
            end
          end
        end
      end

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
            logger.error "#{exception.class}: '#{exception.message}' - #{try} tries in #{elapsed_time} seconds and #{next_interval} seconds until the next try."
          else
            logger.error "#{exception.class}: '#{exception.message}' - #{try} tries in #{elapsed_time} seconds. Task failed."
          end
        end
      end

      def show_result_report(dag)
        reporter = Tumugi::DAGResultReporter.new
        report = reporter.show(dag)
        logger.info "Result report:\n#{report.to_s}"
      end

      def logger
        Tumugi::Logger.instance
      end

      def task_timeout(task)
        timeout = task.timeout || Tumugi.config.timeout
        timeout = nil if !timeout.nil? && timeout == 0 # for backward compatibility
        timeout
      end

      def setup_task_queue(dag)
        @queue = Queue.new
        dag.tsort.each do |t|
          @queue << t
        end
        @queue
      end

      def dequeue_task
        lambda {
          begin
            @queue.pop(true)
          rescue ThreadError
            Parallel::Stop
          end
        }
      end

      def enqueu_task(task)
        sleep 1
        @queue << task
      end
    end
  end
end
