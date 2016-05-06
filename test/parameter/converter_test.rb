require_relative '../test_helper'
require 'tumugi/parameter/converter'

class Tumugi::Parameter::ConverterTest < Test::Unit::TestCase
  setup do
    @converter = Tumugi::Parameter::Converter
  end

  data({
    "string" => ["a", "a"],
    "empty"  => ["", ""],
    "nil"    => [nil, nil],
  })
  test 'string' do |(expected, data)|
    assert_equal(expected, @converter.convert(:string, data))
  end

  sub_test_case 'integer' do
    data({
      "0"  => [0, "0"],
      "1"  => [1, "1"],
      "-1" => [-1, "-1"],
    })
    test 'valid value' do |(expected, data)|
      assert_equal(expected, @converter.convert(:integer, data))
    end

    data({
      "string" => "a",
      "bool"   => "true",
      "time"   => "2016-05-05"
    })
    test 'invalid value' do |data|
      assert_raise(ArgumentError) do
        @converter.convert(:integer, data)
      end
    end
  end

  sub_test_case 'float' do
    data({
      "0"    => [0.0, "0"],
      "1"    => [1.0, "1"],
      "1.5"  => [1.5, "1.5"],
      "-1.5" => [-1.5, "-1.5"],
    })
    test 'valid value' do |(expected, data)|
      assert_equal(expected, @converter.convert(:float, data))
    end

    data({
      "string" => "a",
      "bool"   => "true",
      "time"   => "2016-05-05"
    })
    test 'invalid value' do |data|
      assert_raise(ArgumentError) do
        @converter.convert(:float, data)
      end
    end
  end

  sub_test_case 'bool' do
    data({
      "true"  => [true, "true"],
      "false" => [false, "false"],
    })
    test 'valid value' do |(expected, data)|
      assert_equal(expected, @converter.convert(:bool, data))
    end

    data({
      "string" => "a",
      "integer"=> "1",
      "time"   => "2016-05-05"
    })
    test 'invalid value' do |data|
      assert_raise(ArgumentError) do
        @converter.convert(:bool, data)
      end
    end
  end

  sub_test_case 'time' do
    data({
      "%Y/%m"    => [[2016, 1, 1, 0, 0, 0], "2016/1"],
      "%Y-%m-%d" => [[2016, 1, 2, 0, 0, 0], "2016-01-02"],
      "full"     => [[2016, 2, 3, 1, 2, 3], "2016-02-03T01:02:03"],
    })
    test 'valid value' do |(expected, data)|
      time = @converter.convert(:time, data)
      assert_equal(expected[0], time.year)
      assert_equal(expected[1], time.month)
      assert_equal(expected[2], time.day)
      assert_equal(expected[3], time.hour)
      assert_equal(expected[4], time.min)
      assert_equal(expected[5], time.sec)
    end

    data({
      "string" => "a",
      "integer"=> "1",
    })
    test 'invalid value' do |data|
      assert_raise(ArgumentError) do
        @converter.convert(:time, data)
      end
    end
  end

  test 'invalid type' do
    assert_raise(ArgumentError) do
      @converter.convert(:invalid, 'a')
    end
  end
end
