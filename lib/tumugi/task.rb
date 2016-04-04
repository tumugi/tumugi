module Tumugi
  class Task
    def initialize
    end

    def id
      @id ||= self.class.name
    end

    def id=(s)
      @id = s
    end

    def eql?(other)
      self.hash == other.hash
    end

    def hash
      self.id.hash
    end

    def create_task
      self
    end

    def requires
      [] # If you need to define task dependencies, override in subclass
    end

    def run
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end
  end
end
