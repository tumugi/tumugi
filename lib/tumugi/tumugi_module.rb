require 'forwardable'
require 'tumugi/application'

module Tumugi
  class Logger
    extend Forwardable
    def_delegators :@logger, :debug, :error, :fatal, :info, :warn, :level

    def initialize
      @logger = ::Logger.new(STDOUT)
      @logger.level = ::Logger::INFO
    end

    def verbose!
      @logger.level = ::Logger::DEBUG
    end

    def quiet!
      @logger = ::Logger.new(nil)
    end
  end

  class << self
    def application
      @application ||= Tumugi::Application.new
    end

    def logger
      @logger ||= Tumugi::Logger.new
    end
  end
end
