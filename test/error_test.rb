require_relative './test_helper'
require 'tumugi/error'

class Tumugi::TumugiErrorTest < Test::Unit::TestCase
  test 'TumugiError' do
    err = Tumugi::TumugiError.new
    assert_equal('Tumugi::TumugiError', err.message)
    assert_nil(err.reason)

    err = Tumugi::TumugiError.new('message')
    assert_equal('message', err.message)
    assert_nil(err.reason)

    reason = RuntimeError.new('wrapped')
    err = Tumugi::TumugiError.new('message', reason)
    assert_equal('message', err.message)
    assert_equal(reason, err.reason)
  end

  test 'ConfigError' do
    err = Tumugi::ConfigError.new
    assert_equal('Tumugi::ConfigError', err.message)
    assert_nil(err.reason)

    err = Tumugi::ConfigError.new('message')
    assert_equal('message', err.message)
    assert_nil(err.reason)

    reason = RuntimeError.new('wrapped')
    err = Tumugi::ConfigError.new('message', reason)
    assert_equal('message', err.message)
    assert_equal(reason, err.reason)
  end

  test 'ParameterError' do
    err = Tumugi::ParameterError.new
    assert_equal('Tumugi::ParameterError', err.message)
    assert_nil(err.reason)

    err = Tumugi::ParameterError.new('message')
    assert_equal('message', err.message)
    assert_nil(err.reason)

    reason = RuntimeError.new('wrapped')
    err = Tumugi::ParameterError.new('message', reason)
    assert_equal('message', err.message)
    assert_equal(reason, err.reason)
  end
end
