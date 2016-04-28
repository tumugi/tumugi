require 'forwardable'

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
end
