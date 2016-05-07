module Tumugi
  class Config
    attr_accessor :workers, :max_retry, :retry_interval, :param_auto_bind_enabled

    def initialize
      @workers = 1
      @max_retry = 3
      @retry_interval = 300 #seconds
      @param_auto_bind_enabled = true
      @sections = {}
    end

    def section(name)
      @sections[name] ||= {}
      yield @sections[name] if block_given?
      @sections[name]
    end
  end
end
