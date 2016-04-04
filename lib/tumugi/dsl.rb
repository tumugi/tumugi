# Tumugi DSL functions.

require 'tumugi/task_definition'

module Tumugi
  module DSL
    private

    def task(*args, &block)
      Tumugi::TaskDefinition.define_task(*args, &block)
    end

    def requires(*args, &block)
    end

    def run(*args, &block)
    end
  end
end

# Extend the main object with the DSL commands.
# This allows top-level calls to task, etc.
extend Tumugi::DSL
