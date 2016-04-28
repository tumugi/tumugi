module Tumugi
  class Config
    attr_accessor :workers, :max_retry, :retry_interval

    def initialize
      @workers = 1
      @max_retry = 3
      @retry_interval = 300 #seconds
    end
  end
end
