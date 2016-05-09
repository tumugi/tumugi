require_relative './test_helper'
require 'tumugi/application'

class Tumugi::ApplictionTest < Test::Unit::TestCase
  setup do
    @app = Tumugi::Application.new
  end

  sub_test_case '#setup_logger' do
    test 'default log level is INFO' do
      @app.send(:setup_logger, {})
      assert_equal(Logger::INFO, Tumugi.logger.level)
    end

    test 'log level is DEBUG when verbose flag is true' do
      @app.send(:setup_logger, verbose: true)
      assert_equal(Logger::DEBUG, Tumugi.logger.level)
    end

    test 'log is disabled when quiet flag is true' do
      @app.send(:setup_logger, quiet: true)
      result = capture_stdout { Tumugi.logger.info 'test' }
      assert_equal('', result)
    end
  end
end
