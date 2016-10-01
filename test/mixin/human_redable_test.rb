require_relative '../test_helper'
require 'tumugi/mixin/human_readable'

class Tumugi::Mixin::HumanReadableTest < Test::Unit::TestCase
  include Tumugi::Mixin::HumanReadable

  data(
    '0'     => ['0 second', 0],
    '1'     => ['1 second', 1],
    '2'     => ['2 seconds', 2],
    '59'    => ['59 seconds', 59],
    '60'    => ['1 minute 0 second', 60],
    '61'    => ['1 minute 1 second', 61],
    '122'   => ['2 minutes 2 seconds', 122],
    '3599'  => ['59 minutes 59 seconds', 3599],
    '3600'  => ['1 hour 0 minute 0 second', 3600],
    '3601'  => ['1 hour 0 minute 1 second', 3601],
    '86399' => ['23 hours 59 minutes 59 seconds', 86399],
    '86400' => ['1 day 0 hour 0 minute 0 second', 86400],
    '86401' => ['1 day 0 hour 0 minute 1 second', 86401],
  )
  test '#human_readable_time' do |(expected, target)|
    assert_equal(expected, human_readable_time(target))
  end
end
