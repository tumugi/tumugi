require_relative '../test_helper'
require 'tumugi/parameter/parameter'

class Tumugi::Parameter::ParameterTest < Test::Unit::TestCase
  sub_test_case '#initialize' do
    test 'without options, returns default options' do
      param = Tumugi::Parameter::Parameter.new(:name)
      assert_equal(true, param.auto_bind?)
      assert_equal(false, param.required?)
      assert_equal(:string, param.type)
      assert_equal(nil, param.default_value)
    end

    test 'with options, return specified value' do
      opts = {
        auto_bind: false,
        required: true,
        type: :int,
        default: 1,
      }
      param = Tumugi::Parameter::Parameter.new(:name, opts)
      assert_equal(false, param.auto_bind?)
      assert_equal(true, param.required?)
      assert_equal(:int, param.type)
      assert_equal(1, param.default_value)
    end
  end

  sub_test_case '#get' do
    sub_test_case 'auto_bind is enabled' do
      test 'returns default value when binding value not found in any scope' do
        param = Tumugi::Parameter::Parameter.new(:not_found, default: 'default')
        assert_equal('default', param.get)
      end
    end

    sub_test_case 'auto_bind is disabled' do
      test 'returns nil when default value is not set' do
        param = Tumugi::Parameter::Parameter.new(:name, auto_bind: false)
        assert_equal(nil, param.get)
      end

      test 'returns default value' do
        param = Tumugi::Parameter::Parameter.new(:name, auto_bind: false, default: 'default')
        assert_equal('default', param.get)
      end
    end
  end
end
