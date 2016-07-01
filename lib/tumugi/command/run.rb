require 'tumugi/dag_result_reporter'
require 'tumugi/executor/local_executor'

module Tumugi
  module Command
    class Run
      def execute(dag, options={})
        worker_num = options[:workers] || Tumugi.config.workers
        executor = Tumugi::Executor::LocalExecutor.new(dag, logger, worker_num: worker_num)
        start(executor)
        show_result_report(dag)
        !dag.tsort.any? { |t| t.state == :failed }
      end

      private

      def start(executor)
        logger.info "start workflow: #{Tumugi.workflow.id}"
        executor.execute
        logger.info "end workflow: #{Tumugi.workflow.id}"
      end

      def show_result_report(dag)
        reporter = Tumugi::DAGResultReporter.new
        report = reporter.show(dag)
        logger.info "Result report:\n#{report.to_s}"
      end

      def logger
        Tumugi::Logger.instance
      end
    end
  end
end
