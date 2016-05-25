require_relative '../../test_helper'
require 'tumugi/plugin/task/external'

class Tumugi::Plugin::ExternalTaskTest < Test::Unit::TestCase
  setup do
    @task = Tumugi::Plugin::ExternalTask.new
  end

  test 'plugin' do
    assert_equal(Tumugi::Plugin::ExternalTask, Tumugi::Plugin.lookup_task('external'))
  end

  test 'can call #run without any error' do
    @task.run
  end
end
