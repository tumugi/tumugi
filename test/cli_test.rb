require_relative './test_helper'
require 'tumugi/cli'

class Tumugi::CLITest < Test::Unit::TestCase
  examples = {
    'concurrent_task_run' => ['concurrent_task_run.rb', 'task1'],
    'data_pipeline' => ['data_pipeline.rb', 'sum'],
    'simple' => ['simple.rb', 'task1'],
    'target' => ['target.rb', 'task1'],
    'task_inheritance' => ['task_inheritance.rb', 'task1'],
    'task_parameter' => ['task_parameter.rb', 'task1'],
  }

  failed_examples = {
    'fail_first_task' => ['fail_first_task.rb', 'task1'],
    'fail_intermediate_task' => ['fail_intermediate_task.rb', 'task1'],
    'fail_last_task' => ['fail_last_task.rb', 'task1'],
  }

  config_section_examples = {
    'config_section' => ['config_section.rb', 'task1'],
  }

  def invoke(command, file, task, options)
    Tumugi::CLI.new.invoke(command, [task], options.merge(file: "./examples/#{file}"))
  end

  setup do
    system('rm -rf tmp/tumugi_*')
  end

  sub_test_case 'run' do
    data(examples)
    test 'success' do |(file, task)|
      assert_true(invoke(:run_, file, task, params: { 'key1' => 'value1' }, workers: 4, config: "./examples/tumugi_config.rb"))
    end

    data(failed_examples)
    test 'fail' do |(file, task)|
      assert_raise(Thor::Error) do
        invoke(:run_, file, task, workers: 4, config: "./examples/tumugi_config.rb")
      end
    end

    data(config_section_examples)
    test 'config_section' do |(file, task)|
      assert_true(invoke(:run_, file, task, workers: 4, config: "./examples/tumugi_config_with_section.rb", output: 'tmp/tumugi.log'))
    end

    test 'logfile' do
      assert_true(invoke(:run_, 'simple.rb', 'task1', out: 'tmp/tumugi.log', config: "./examples/tumugi_config.rb"))
      assert_true(File.exist?('tmp/tumugi.log'))
    end
  end

  sub_test_case 'show' do
    data(examples)
    test 'without output' do |(file, task)|
      capture_stdout do
        assert_true(invoke(:show, file, task, params: { 'key1' => 'value1' }))
      end
    end

    data do
      data_set = {}
      examples.each do |k, v|
        %w(dot jpg pdf png svg).each do |fmt|
          data_set["#{k}_#{fmt}"] = (v << fmt)
        end
      end
      data_set
    end
    test 'with valid output' do |(file, task, format)|
      capture_stdout do
        assert_true(invoke(:show, file, task, output: "tmp/#{file}.#{format}", params: { 'key1' => 'value1' }))
      end
    end
  end
end
