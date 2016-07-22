require 'tumugi/logger/logger'
require 'forwardable'

module Tumugi
  class ScopedLogger
    extend Forwardable
    def_delegators :@logger, :debug?, :error?, :fatal?, :info?, :warn?, :level

    def initialize(scope)
      @scope = scope
      @logger = Tumugi::Logger.instance
    end

    [:debug, :errror, :fatal, :info, :warn].each do |level|
      class_eval "def #{level}(msg=nil, &block); log(:#{level}, msg, &block) end", __FILE__, __LINE__
    end

    def trace(msg=nil, &block)
      if ENV.key?("TUMUGI_DEBUG")
        log(:debug, msg, &block)
      end
    end

    private

    def log(level, msg=nil, &block)
      if block_given?
        @logger.send(level, "#{@scope}", &block)
      else
        @logger.send(level, "#{@scope}") { msg }
      end
    end
  end
end
