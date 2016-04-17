require 'test_helper'
require 'tumugi/dsl'

class Tumugi::DSLTest < Test::Unit::TestCase
  include Tumugi::DSL

  test '#task' do
    mock.proxy(Tumugi::TaskDefinition).define(:test1)
    result = task(:test1) {}
    assert_equal(Tumugi::TaskDefinition, result.class)
    assert_equal(:test1, result.id)
  end
end
