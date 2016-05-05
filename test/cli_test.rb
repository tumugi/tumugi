require_relative './test_helper'

class Tumugi::CLITest < Test::Unit::TestCase
  examples = {
    'concurrent_task_run' => ['concurrent_task_run.rb', 'task1'],
    'data_pipeline' => ['data_pipeline.rb', 'sum'],
    'simple' => ['simple.rb', 'task1'],
    'target' => ['target.rb', 'task1'],
    'task_inheritance' => ['task_inheritance.rb', 'task1'],
    'task_parameter' => ['task_parameter.rb', 'task1'],
  }

  setup do
    system('rm -rf /tmp/tumugi_*')
  end

  data(examples)
  test 'run' do |(file, task)|
    assert_true(system("bundle exec ./exe/tumugi run -f ./examples/#{file} -w 4 --quiet #{task} -p key1:value1"))
  end

  sub_test_case 'show' do
    data(examples)
    test 'without output' do |(file, task)|
      assert_true(system("bundle exec ./exe/tumugi show -f ./examples/#{file} #{task} -p key1:value1"))
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
      assert_true(system("bundle exec ./exe/tumugi show -f ./examples/#{file} #{task} -o tmp/#{file}.#{format} -p key1:value1"))
    end
  end
end
