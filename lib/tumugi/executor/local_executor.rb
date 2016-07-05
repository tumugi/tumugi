require 'much-timeout'
require 'parallel'

require 'tumugi'
require 'tumugi/error'

module Tumugi
  module Executor
    class LocalExecutor
      def initialize(dag, logger=nil, worker_num: 1)
        @dag = dag
        @last_task = dag.tsort.last
        @logger = logger || Tumugi::Logger.instance
        @options = { worker_num: worker_num }
        @mutex = Mutex.new
      end

      def execute
        setup_task_queue(@dag)
        Parallel.each(dequeue_task, { in_threads: @options[:worker_num] }) do |task|
          @logger.info "start: #{task.id}, worker_number: #{Parallel.worker_number}"

          if !task.runnable?(Time.now)
            sleep(task_wait_sec)
            enqueue_task(task)
            next
          end

          begin
            task.start!
            MuchTimeout.optional_timeout(task_timeout(task), Tumugi::TimeoutError) do
              task.run
            end
            task.mark_completed!
            @logger.info "#{task.state}: #{task.id}"
          rescue => e
            handle_error(task, e)
          end
        end
        @dag.tsort.all? { |t| t.success? }
      end

      private

      def task_timeout(task)
        timeout = task.timeout || Tumugi.config.timeout
        timeout = nil if !timeout.nil? && timeout == 0 # for backward compatibility
        timeout
      end

      def task_wait_sec
        1 # TODO: Make this configurable
      end

      def setup_task_queue(dag)
        @queue = []
        dag.tsort.each { |t| enqueue_task(t) }
        @queue
      end

      def dequeue_task
        lambda {
          loop do
            task = @mutex.synchronize {
              @logger.debug "queue: #{@queue.map(&:id)}"
              @queue.shift
            }

            if task.nil?
              if @last_task.finished?
                break Parallel::Stop
              else
                sleep(task_wait_sec)
              end
            else
              @logger.debug "dequeue: #{task.id}"

              if task.requires_failed?
                task.mark_requires_failed!
                @logger.info "#{task.state}: #{task.id} has failed requires task"
              elsif task.completed?
                task.skip!
                @logger.info "#{task.state}: #{task.id} is already completed"
              else
                break task
              end
            end
          end
        }
      end

      def enqueue_task(task)
        @logger.debug "enqueue: #{task.id}"
        @mutex.synchronize { @queue.push(task) }
      end

      def handle_error(task, err)
        if task.retry(err)
          task.pend!
          @logger.error "#{err.class}: '#{err.message}' - #{task.tries} tries and wait #{task.retry_interval} seconds until the next try."
          enqueue_task(task)
        else
          task.mark_failed!
          @logger.error "#{err.class}: '#{err.message}' - #{task.tries} tries and reached max retry count, so task #{task.id} failed."
          @logger.info "#{task.state}: #{task.id}"
          @logger.error "#{err.message}"
          @logger.debug err.backtrace.join("\n")
        end
      end
    end
  end
end
