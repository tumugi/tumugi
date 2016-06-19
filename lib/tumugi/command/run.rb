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
        start(task_queue(dag), settings)
        show_result_report(dag)
        !dag.tsort.any? { |t| t.state == :failed }
      end

      private

      def task_queue(dag)
        waiting_task_queue = Queue.new
        available_task_queue = Queue.new
        dag.tsort.each do |t|
          if t.ready?
            available_task_queue << t
          else
            waiting_task_queue << t
          end
        end
        lambda {
          task = (available_task_queue.empty? ? nil : available_task_queue.pop)
          if task.nil?
            task = (waiting_task_queue.empty? ? nil : waiting_task_queue.pop)
          end
          task || Parallel::Stop
        }
      end

      def start(proc, settings)
        Parallel.each(proc, settings) do |t|
          logger.info "start: #{t.id}"
          timeout = t.timeout || Tumugi.config.timeout
          Timeout::timeout(timeout, Tumugi::TimeoutError) do
            until t.ready? || t.requires_failed?
              sleep 5
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
        headings = ['Task', 'Requires', 'Parameters', 'State']
        table = Terminal::Table.new title: "Workflow Result", headings: headings do |t|
          dag.tsort.map.with_index do |task, index|
            proxy = task.class.merged_parameter_proxy
            requires = list(task.requires).map do |r|
              r.id
            end
            params = proxy.params.map do |name, _|
              "#{name}=#{truncate(task.send(name.to_sym), 15)}"
            end
            t << :separator if index != 0
            t << [ task.id, requires.join("\n"), params.join("\n"), task.state ]
          end
        end
        logger.info "Result report:\n#{table.to_s}"
      end

      def logger
        Tumugi::Logger.instance
      end

      def truncate(text, length)
        return nil if text.nil?
        if text.length <= length
          text
        else
          text[0, length].concat('...')
        end
      end
    end
  end
end
