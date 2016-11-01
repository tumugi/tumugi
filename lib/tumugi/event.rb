module Tumugi
  module Event
    SUCCESS = :success
    FAILURE = :failure
    RETRY = :retry

    def self.all
      self.constants.map{|name| self.const_get(name) }
    end
  end
end
