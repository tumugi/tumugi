require 'fileutils'
require 'json'
require 'tumugi/mixin/listable'

module Tumugi
  module Reporter
    class WorkflowReporter
      include Tumugi::Mixin::Listable
      attr_reader :workflow, :dag

      def initialize(workflow, dag)
        @workflow = workflow
        @dag = dag
      end

      def save(dir)
        FileUtils.mkdir_p(dir)
        filename = File.join(dir, "tumugi-result-#{@workflow.id}.json")
        File.open(filename, 'w') do |f|
          f.write JSON.pretty_generate(report)
        end
      end

      def report
        @report ||= {
          "id" => workflow.id,
          "success" => workflow.success?,
          "start_time" => workflow.start_time.iso8601,
          "end_time" => workflow.end_time.iso8601,
          "tasks" => tasks,
        }
      end

      def tasks
        outputs = []
        dag.tsort.map.with_index do |task, index|
          output = {
            "id" => task.id,
            "state" => task.state,
            "elapsed_time" => task.elapsed_time,
            "params" => [],
          }

          proxy = task.class.merged_parameter_proxy
          output["requires"] = list(task.requires).map{|r| r.id}
          proxy.params.map do |name, param|
            output["params"] << { "name" => get_param(task, param, name) }
          end
          outputs << output
        end
        outputs
      end

      def get_param(task, param, name)
        param.secret? ? '***' : task.send(name.to_sym).to_s
      end
    end
  end
end
