require 'tumugi'

module Tumugi
  class Target
    def initialize
      super()
    end

    def exist?
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    def logger
      @logger ||= Tumugi::ScopedLogger.new(self.class.name)
    end

    def log(msg)
      logger.info(msg)
    end
  end
end
