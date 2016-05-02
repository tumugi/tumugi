require 'tumugi'

module Tumugi
  class Target
    def exist?
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    def logger
      @logger ||= Tumugi.logger
    end

    def log(msg)
      logger.info(msg)
    end
  end
end
