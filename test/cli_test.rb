require_relative './test_helper'

class Tumugi::CLITest < Test::Unit::TestCase
  examples = {
    'concurrent_task_run' => ['concurrent_task_run.rb', 'task1'],
    'config_section' => ['config_section.rb', 'task1'],
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

  def exec(command, file, task, options)
    system("bundle exec ./exe/tumugi #{command} -f ./examples/#{file} #{task} #{options}")
  end

  setup do
    system('rm -rf /tmp/tumugi_*')
  end

  sub_test_case 'run' do
    data(examples)
    test 'success' do |(file, task)|
      assert_true(exec('run', file, task, "-w 4 --quiet -p key1:value1 -c ./examples/tumugi_config.rb"))
    end

    data(failed_examples)
    test 'fail' do |(file, task)|
      assert_false(exec('run', file, task, "-w 4 --quiet -c ./examples/tumugi_config.rb"))
    end
  end

  sub_test_case 'show' do
    data(examples)
    test 'without output' do |(file, task)|
      assert_true(exec('show', file, task, "-p key1:value1"))
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
      assert_true(exec('show', file, task, "-o tmp/#{file}.#{format} -p key1:value1"))
    end
  end
end
