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

    def instance
      self
    end

    # If you need to define task dependencies, override in subclass
    def requires
      []
    end

    # If you need to define output of task to skip alredy done task,
    # override in subclass. If not, a task run always.
    def output
      []
    end

    def run
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    def completed?
      outputs = list(output)
      !outputs.empty? && outputs.all?(&:exist?)
    end

    private

    def list(obj)
      return [] if obj.nil?
      return obj if obj.is_a?(Array) || obj.is_a?(Hash)
      return [obj]
    end
  end
end
