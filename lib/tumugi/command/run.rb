require 'tumugi/executor/local_executor'

module Tumugi
  module Command
    class Run
      def execute(dag, options={})
        worker_num = options[:workers] || Tumugi.config.workers
        executor = Tumugi::Executor::LocalExecutor.new(dag, worker_num: worker_num, run_all: options[:all])
        executor.execute
      end

      def logger
        @logger ||= Tumugi::ScopedLogger.new("tumugi-run")
      end
    end
  end
end
