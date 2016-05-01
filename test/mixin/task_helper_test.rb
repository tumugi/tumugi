require_relative '../test_helper'
require 'tumugi/mixin/task_helper'

class Tumugi::Mixin::TaskHelperTest < Test::Unit::TestCase
  include Tumugi::Mixin::TaskHelper

  sub_test_case '#target' do
    test 'should return instance of specified target' do
      path = 'test.txt'
      t = target(:file, path)
      assert_true(t.is_a?(Tumugi::Plugin::FileTarget))
      assert_equal(path, t.path)
    end

    test 'should raise error if target is not registered' do
      assert_raise do
        target(:not_registered)
      end
    end
  end
end
