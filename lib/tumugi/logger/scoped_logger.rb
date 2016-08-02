require 'tumugi/logger/logger'
require 'forwardable'

module Tumugi
  class ScopedLogger
    extend Forwardable
    def_delegators :@logger, :init, :verbose!, :quiet!, :workflow_id, :workflow_id=,
                             :debug?, :error?, :fatal?, :info?, :warn?, :level

    def initialize(scope)
      @scope = scope
      @logger = Tumugi::Logger.instance
    end

    [:debug, :error, :fatal, :info, :warn].each do |level|
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
        @logger.send(level, progname, &block)
      else
        @logger.send(level, progname) { msg }
      end
    end

    def progname
      if @scope.is_a?(Proc)
        @scope.call
      else
        @scope.to_s
      end
    end
  end
end
