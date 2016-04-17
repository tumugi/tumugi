require "gviz"

module Tumugi
  module Command
    class Show
      def execute(dag, options)
        type = options[:type]
        out = options[:out]

        graph = Graph do
          dag.tsort.each do |task|
            route task.id => task._requires.map {|t| t.id}
          end
        end

        if out.present?
          file_base_path = "#{File.dirname(out)}/#{File.basename(out, '.*')}"
          graph.save(file_base_path, type == 'dot' ? nil : type)
        else
          print graph
        end
      end
    end
  end
end
