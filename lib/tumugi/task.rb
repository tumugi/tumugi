module Tumugi
  class Task
    include Tumugi::Helper

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

    def input
      if requires.nil?
        []
      elsif requires.is_a?(Array)
        requires.map { |t| t.instance.output }
      elsif requires.is_a?(Hash)
        Hash[requires.map { |k, t| [k, t.instance.output] }]
      else
        requires.instance.output
      end
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
  end
end
