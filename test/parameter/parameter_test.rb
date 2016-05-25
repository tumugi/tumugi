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
        required: false,
        type: :integer,
        default: 1,
      }
      param = Tumugi::Parameter::Parameter.new(:name, opts)
      assert_equal(false, param.auto_bind?)
      assert_equal(false, param.required?)
      assert_equal(:integer, param.type)
      assert_equal(1, param.default_value)
    end

    test 'raise ParameterError when both required and default is set' do
      assert_raise(Tumugi::ParameterError) do
        Tumugi::Parameter::Parameter.new(:name, required: true, default: 'test')
      end
    end
  end

  sub_test_case '#auto_bind?' do
    teardown do
      Tumugi.configure do |config|
        config.param_auto_bind_enabled = true
      end
    end

    test 'should return false when global param_auto_bind_enabled is false' do
      Tumugi.configure do |config|
        config.param_auto_bind_enabled = false
      end
      param = Tumugi::Parameter::Parameter.new(:name)
      assert_false(param.auto_bind?)
    end

    test 'should return false when task param_auto_bind_enabled is false' do
      param = Tumugi::Parameter::Parameter.new(:name)
      param.task_param_auto_bind_enabled = false
      assert_false(param.auto_bind?)
    end

    test 'should return true when auto_bind option is true' do
      Tumugi.configure do |config|
        config.param_auto_bind_enabled = false
      end
      param = Tumugi::Parameter::Parameter.new(:name, auto_bind: true)
      assert_true(param.auto_bind?)
    end
  end

  sub_test_case '#get' do
    sub_test_case 'auto_bind is enabled' do
      sub_test_case 'search from application parameter' do
        teardown do
          Tumugi.application.params = {}
        end

        test 'returns specified value' do
          Tumugi.application.params['param_1'] = 'param_value1'
          param = Tumugi::Parameter::Parameter.new(:param_1)
          assert_equal('param_value1', param.get)
        end
      end

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

  sub_test_case '#merge_default_value' do
    test 'should merge default value' do
      param = Tumugi::Parameter::Parameter.new(:name, default: 'default')
      merged = param.merge_default_value('value1')
      assert_equal('value1', merged.get)
    end

    test 'should disable required implicitly' do
      param = Tumugi::Parameter::Parameter.new(:name, required: true)
      merged = param.merge_default_value('value1')
      assert_equal('value1', merged.get)
      assert_false(merged.required?)
    end
  end
end
