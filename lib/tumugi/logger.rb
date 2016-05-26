require 'logger'
require 'forwardable'
require 'singleton'

module Tumugi
  class Logger
    include Singleton
    extend Forwardable
    def_delegators :@logger, :debug, :error, :fatal, :info, :warn, :level

    def init(output=STDOUT)
      @logger = ::Logger.new(output)
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
