require "gviz"

module Tumugi
  module Command
    class Show
      def execute(dag, options)
        dot = Graph do
          dag.tsort.each do |task|
            route task.id => task._requires.map {|t| t.id}
          end
        end
        puts dot
      end
    end
  end
end
