require 'tumugi/mixin/listable'
require 'tumugi/mixin/task_helper'
require 'tumugi/mixin/parameterizable'

module Tumugi
  class Task
    include Tumugi::Mixin::Parameterizable
    include Tumugi::Mixin::Listable
    include Tumugi::Mixin::TaskHelper

    attr_accessor :state # :pending, :running, :completed, :skipped

    def initialize
      super()
      @state = :pending
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

    def logger
      @logger ||= Tumugi.logger
    end

    def log(msg)
      logger.info(msg)
    end

    # If you need to define task dependencies, override in subclass
    def requires
      []
    end

    def input
      @input ||= _input
    end

    # If you need to define output of task to skip alredy done task,
    # override in subclass. If not, a task run always.
    def output
      []
    end

    def run
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    def ready?
      list(_requires).all? { |t| t.instance.completed? }
    end

    def completed?
      outputs = list(output)
      if outputs.empty?
        @state == :completed || @state == :skipped
      else
        outputs.all?(&:exist?)
      end
    end

    def requires_failed?
      list(_requires).any? { |t| t.instance.state == :failed || t.instance.state == :requires_failed }
    end

    def timeout
      nil # meaning use default timeout
    end

    # Following methods are internal use only

    def _requires
      @_requires ||= requires
    end

    def _output
      @_output ||= output
    end

    private

    def _input
      if _requires.nil?
        []
      elsif _requires.is_a?(Array)
        _requires.map { |t| t.instance._output }
      elsif _requires.is_a?(Hash)
        Hash[_requires.map { |k, t| [k, t.instance._output] }]
      else
        _requires.instance._output
      end
    end
  end
end
