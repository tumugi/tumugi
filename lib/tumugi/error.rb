module Tumugi
  class TumugiError < StandardError
    attr_reader :reason

    def initialize(message=nil, reason=nil)
      super(message)
      @reason = reason
    end
  end

  class ConfigError < TumugiError
  end

  class ParameterError < TumugiError
  end

  class TimeoutError < TumugiError
  end
end
