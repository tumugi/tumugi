require 'test_helper'

class Tumugi::HelperTest < Test::Unit::TestCase
  include Tumugi::Helper

  data(
    'nil'    => [[], nil],
    'array'  => [[1,2], [1,2]],
    'hash'   => [{key1: 'val1', key2: 'val2'}, ['val1', 'val2']],
    'object' => [['test'], 'test'],
  )
  test '#list' do |expected, obj|
    assert_equal(expected, list(obj))
  end
end
