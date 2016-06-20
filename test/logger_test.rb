require_relative './test_helper'
require 'tumugi/logger'

class Tumugi::LoggerTest < Test::Unit::TestCase
  setup do
    @logger = Tumugi::Logger.instance
    @logger.job = @job = Tumugi::Job.new
    @logger.init
    @log_file = 'tmp/test.log'
  end

  teardown do
    File.delete(@log_file) if File.exist?(@log_file)
  end

  test 'verbose!' do
    assert_equal(::Logger::INFO, @logger.level)
    @logger.verbose!
    assert_equal(::Logger::DEBUG, @logger.level)
  end

  test 'quiet!' do
    output = StringIO.new
    @logger.init(output: output)
    @logger.quiet!
    @logger.info 'test'
    assert_equal('', output.string)
  end

  test 'should respond to delegated methods' do
    [:debug, :error, :fatal, :info, :warn, :level].each do |method|
      assert_true(@logger.respond_to?(method))
    end
  end

  test 'output to file' do
    @logger.init(output: @log_file)
    @logger.info('test')
    assert_true(File.exist?(@log_file))
  end

  data({
    "text" => [:text, proc{ |logger| /\d{4}\-\d{2}\-\d{2} \d{2}:\d{2}:\d{2} \+\d{4} INFO \[#{logger.job.id}\] test\n$/ }],
    "json" => [:json, proc{ |logger| /\{"time":"\d{4}\-\d{2}\-\d{2} \d{2}:\d{2}:\d{2} \+\d{4}","severity\":"INFO","job":"#{logger.job.id}","message":"test"\}\n$/ }]
  })
  test 'log format' do |(format, expected)|
    output = StringIO.new
    @logger.init(output: output, format: format)
    @logger.info 'test'
    assert_match(expected.call(@logger), output.string)
  end
end
