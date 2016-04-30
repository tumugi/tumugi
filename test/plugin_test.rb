require 'test_helper'
require 'tumugi/registry'

class Tumugi::PluginTest < Test::Unit::TestCase
  sub_test_case 'target' do
    test 'should raise error when target is not registered' do
      assert_raise do
        Tumugi::Plugin.lookup_target(:not_registered)
      end
    end

    test 'can lookup default plugin' do
      klass = Tumugi::Plugin.lookup_target(:file)
      assert_equal(klass, Tumugi::FileTarget)
    end

    test 'can lookup registered plugin' do
      class TestTarget < Tumugi::Target
        Tumugi::Plugin.register_target(:test, self)
      end
      klass = Tumugi::Plugin.lookup_target(:test)
      assert_equal(klass, TestTarget)
    end
  end

  sub_test_case 'task' do
    test 'should raise error when task is not registered' do
      assert_raise do
        Tumugi::Plugin.lookup_task(:not_registered)
      end
    end

    test 'can lookup registered plugin' do
      class TestTask < Tumugi::Task
        Tumugi::Plugin.register_task(:test, self)
      end
      klass = Tumugi::Plugin.lookup_task(:test)
      assert_equal(klass, TestTask)
    end
  end
end
