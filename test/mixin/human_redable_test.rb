require_relative '../test_helper'
require 'tumugi/mixin/human_readable'

class Tumugi::Mixin::HumanReadableTest < Test::Unit::TestCase
  include Tumugi::Mixin::HumanReadable

  data(
    '0'     => ['00:00:00', 0],
    '1'     => ['00:00:01', 1],
    '2'     => ['00:00:02', 2],
    '59'    => ['00:00:59', 59],
    '60'    => ['00:01:00', 60],
    '61'    => ['00:01:01', 61],
    '122'   => ['00:02:02', 122],
    '3599'  => ['00:59:59', 3599],
    '3600'  => ['01:00:00', 3600],
    '3601'  => ['01:00:01', 3601],
    '86399' => ['23:59:59', 86399],
    '86400' => ['24:00:00', 86400],
    '90000' => ['25:00:00', 90000],
  )
  test '#human_readable_time' do |(expected, target)|
    assert_equal(expected, human_readable_time(target))
  end
end
