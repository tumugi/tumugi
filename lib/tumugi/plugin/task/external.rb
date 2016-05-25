require 'tumugi/task'

module Tumugi
  module Plugin
    class ExternalTask < Tumugi::Task
      Plugin.register_task(:external, self)

      def run
        # Do nothing
      end
    end
  end
end
