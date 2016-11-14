require 'tumugi/reporter/stdout_reporter'
require 'tumugi/executor/local_executor'

module Tumugi
  module Command
    class Run
      def execute(dag, options={})
        worker_num = options[:workers] || Tumugi.config.workers
        executor = Tumugi::Executor::LocalExecutor.new(dag, worker_num: worker_num, run_all: options[:all])
        result = executor.execute
        show_result_report(dag)
        result
      end

      private

      def show_result_report(dag)
        reporter = Tumugi::Reporter::StdoutReporter.new
        report = reporter.show(dag)
        logger.info "Result report:\n#{report.to_s}"
      end

      def logger
        @logger ||= Tumugi::ScopedLogger.new("tumugi-run")
      end
    end
  end
end
