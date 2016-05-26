require_relative './test_helper'
require 'tumugi/logger'

class Tumugi::LoggerTest < Test::Unit::TestCase
  setup do
    @logger = Tumugi::Logger.instance
    @logger.init

    @log_file = 'tmp/test.log'
    File.delete(@log_file) if File.exist?(@log_file)
  end

  test 'verbose!' do
    assert_equal(::Logger::INFO, @logger.level)
    @logger.verbose!
    assert_equal(::Logger::DEBUG, @logger.level)
  end

  test 'quiet!' do
    @logger.quiet!
    result = capture_stdout { @logger.info 'test' }
    assert_equal('', result)
  end

  test 'should respond to delegated methods' do
    [:debug, :error, :fatal, :info, :warn, :level].each do |method|
      assert_true(@logger.respond_to?(method))
    end
  end

  test 'output to file' do
    @logger.init(@log_file)
    @logger.info('test')
    assert_true(File.exist?(@log_file))
  end
end
