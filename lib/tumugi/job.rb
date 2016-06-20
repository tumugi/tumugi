require 'securerandom'

module Tumugi
  class Job
    attr_reader :id

    def initialize
      @id = SecureRandom.uuid
    end
  end
end
