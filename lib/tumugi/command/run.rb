module Tumugi
  module Command
    class Run
      def execute(dag, options)
        dag.tsort.each do |t|
          unless t.completed?
            puts "run: #{t.id}"
            t.run
          else
            puts "skip: #{t.id} is already completed"
          end
        end
      end
    end
  end
end
