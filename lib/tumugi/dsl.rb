# Tumugi DSL functions.

require 'tumugi/task_definition'

module Tumugi
  module DSL
    def task(*args, &block)
      Tumugi::TaskDefinition.define(*args, &block)
    end
  end
end

# Extend the main object with the DSL commands.
# This allows top-level calls to task, etc.
extend Tumugi::DSL
