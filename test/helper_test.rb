require_relative './test_helper'
require 'tumugi/helper'

class Tumugi::HelperTest < Test::Unit::TestCase
  include Tumugi::Helper

  data(
    'nil'    => [[], nil],
    'array'  => [[1,2], [1,2]],
    'hash'   => [['val1', 'val2'], {key1: 'val1', key2: 'val2'}],
    'object' => [['test'], 'test'],
  )
  test '#list' do |(expected, target)|
    assert_equal(expected, list(target))
  end
end
