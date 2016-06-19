require 'test/unit'
require 'test/unit/rr'

require 'tumugi'
require 'tumugi/cli'

module Tumugi
  module Test
    module Helpers
      def capture_stdout
        out = StringIO.new
        $stdout = out
        yield
        return out.string
      ensure
        $stdout = STDOUT
      end
    end

    class TumugiTestCase < ::Test::Unit::TestCase
      def invoke(command, workflow_file, task, options)
        Tumugi::CLI.new.invoke(command, [task], { file: workflow_file, quiet: true }.merge(options))
      end

      def assert_run_success(workflow_file, task, options={})
        assert_true(invoke(:run_, workflow_file, task, { workers: 2 }.merge(options)))
      end

      def assert_run_fail(workflow_file, task, options={})
        assert_raise(Thor::Error) do
          invoke(:run_, workflow_file, task, options)
        end
      end

      def assert_show_success(workflow_file, task, options={})
        assert_true(invoke(:show, workflow_file, task, options))
      end

      def assert_show_fail(workflow_file, task, options={})
        assert_raise(Thor::Error) do
          invoke(:show, workflow_file, task, options)
        end
      end
    end
  end
end
