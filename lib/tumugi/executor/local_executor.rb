require 'much-timeout'
require 'concurrent'

require 'tumugi'
require 'tumugi/error'

module Tumugi
  module Executor
    class LocalExecutor
      def initialize(dag, worker_num: 1)
        @dag = dag
        @main_task = dag.tsort.last
        @options = { worker_num: worker_num }
        @mutex = Mutex.new
      end

      def execute
        pool = Concurrent::ThreadPoolExecutor.new(
          min_threads: @options[:worker_num],
          max_threads: @options[:worker_num]
        )

        setup_task_queue(@dag)
        loop do
          task = dequeue_task
          break if task.nil?

          Concurrent::Future.execute(executor: pool) do
            if !task.runnable?(Time.now)
              logger.trace { "task_cannot_run: #{task.id}" }
              enqueue_task(task)
            else
              begin
                logger.info { "task_start: #{task.id}" }
                task.trigger!(:start)
                MuchTimeout.optional_timeout(task_timeout(task), Tumugi::TimeoutError) do
                  task.run
                end
                task.trigger!(:complete)
                logger.info { "task_#{task.state}: #{task.id}, elapsed_time: #{task.elapsed_time}" }
              rescue => e
                handle_error(task, e)
              end
            end
          end
        end

        pool.shutdown
        pool.wait_for_termination

        @dag.tsort.all? { |t| t.success? }
      end

      private

      def task_timeout(task)
        timeout = task.timeout || Tumugi.config.timeout
        timeout = nil if !timeout.nil? && timeout == 0 # for backward compatibility
        timeout
      end

      def setup_task_queue(dag)
        @queue = []
        dag.tsort.each { |t| enqueue_task(t) }
        @queue
      end

      def dequeue_task
        loop do
          task = @mutex.synchronize {
            logger.trace { "task_queue_dump: #{@queue.map(&:id)}" } unless @queue.empty?
            @queue.shift
          }

          if task.nil?
            if @main_task.finished?
              break nil
            else
              sleep(0.1)
            end
          else
            logger.trace { "task_queue_dequeue: #{task.id}" }

            if task.requires_failed?
              task.trigger!(:requires_fail)
              logger.info { "task_#{task.state}: #{task.id} has failed requires task, elapsed_time: #{task.elapsed_time}" }
            elsif task.completed?
              task.trigger!(:skip)
              logger.info { "task_#{task.state}: #{task.id} is already completed, elapsed_time: #{task.elapsed_time}" }
            else
              break task
            end
          end
        end
      end

      def enqueue_task(task)
        logger.trace { "task_queue_enqueue: #{task.id}" }
        @mutex.synchronize { @queue.push(task) }
      end

      def handle_error(task, err)
        if task.retry
          task.trigger!(:pend)
          logger.info { "task_#{task.state}: #{task.id} failed, elapsed_time: #{task.elapsed_time}" }
          logger.error { "#{err.class}: '#{err.message}' - #{task.tries} tries and wait #{task.retry_interval} seconds until the next try." }
          enqueue_task(task)
        else
          task.trigger!(:fail)
          logger.info { "task_#{task.state}: #{task.id} failed, elapsed_time: #{task.elapsed_time}" }
          logger.error { "#{err.class}: '#{err.message}' - #{task.tries} tries and reached max retry count, so task #{task.id} failed." }
        end
        logger.error { err.backtrace.join("\n") }
      end

      def logger
        @logger ||= Tumugi::ScopedLogger.new("tumugi-executor")
      end
    end
  end
end
