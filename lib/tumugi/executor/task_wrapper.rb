require 'forwardable'
require 'tumugi'

module Tumugi
  module Executor
    class TaskWrapper
      extend Forwardable
      def_delegators :@task, :id, :state, :state=, :requires_failed?, :completed?, :run, :timeout
      attr_reader :task, :visible_at, :tries, :max_retry, :retry_interval

      def initialize(task, visible_at=Time.now)
        @task = task
        @visible_at = visible_at
        @tries = 0
        @max_retry = Tumugi.config.max_retry
        @retry_interval = Tumugi.config.retry_interval
      end

      def ready?(now)
        @task.ready? && visible?(now)
      end

      def retry(err)
        @tries += 1
        @visible_at += @retry_interval
        retriable?
      end

      private

      def visible?(now)
        now >= @visible_at
      end

      def retriable?
        @tries <= @max_retry
      end
    end
  end
end
