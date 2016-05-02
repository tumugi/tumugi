require_relative '../test_helper'
require 'tumugi/dag'
require 'tumugi/task'
require 'tumugi/command/show'

class Tumugi::Command::ShowTest < Test::Unit::TestCase
  setup do
    @cmd = Tumugi::Command::Show.new
    @dag = Tumugi::DAG.new
    task = Tumugi::Task.new
    task.id = :task1
    @dag.add_task(task)
  end

  sub_test_case '#execute' do
    test 'without output param, dot notation is output to STDOUT' do
      result = capture_stdout { @cmd.execute(@dag) }
      assert_equal("digraph G {\nrankdir = \"RL\";\ntask1 [label = \"task1\"];\n}\n", result)
    end

    data(
      'dot' => 'tmp/test.dot',
      'png' => 'tmp/test.png',
      'jpg' => 'tmp/test.jpg',
      'svg' => 'tmp/test.svg',
      'pdf' => 'tmp/test.pdf',
    )
    test 'output specified formated file' do |output|
      @cmd.execute(@dag, out: output)
      assert_true(File.exists?(output))
    end

    data(
      'txt' => 'test.txt',
      'exe' => 'test.exe',
    )
    test 'raise error when output format is not supported' do |output|
      assert_raise do
        @cmd.execute(@dag, out: output)
      end
    end
  end
end
