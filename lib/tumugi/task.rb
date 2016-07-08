require 'tumugi/mixin/listable'
require 'tumugi/mixin/task_helper'
require 'tumugi/mixin/parameterizable'

module Tumugi
  class Task
    include Tumugi::Mixin::Parameterizable
    include Tumugi::Mixin::Listable
    include Tumugi::Mixin::TaskHelper

    attr_reader :visible_at, :tries, :max_retry, :retry_interval

    AVAILABLE_STATES = [
      :pending,
      :running,
      :completed,
      :skipped,
      :failed,
      :requires_failed,
    ]

    def initialize
      super()
      @visible_at = Time.now
      @tries = 0
      @max_retry = Tumugi.config.max_retry
      @retry_interval = Tumugi.config.retry_interval
      @state = :pending
      @lock = Mutex.new
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
      @logger ||= Tumugi::Logger.instance
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
        success?
      else
        outputs.all?(&:exist?)
      end
    end

    def requires_failed?
      list(_requires).any? { |t| t.instance.finished? && !t.instance.success? }
    end

    def runnable?(now)
      ready? && visible?(now)
    end

    def success?
      case state
      when :completed, :skipped
        true
      else
        false
      end
    end

    def finished?
      case state
      when :completed, :skipped, :failed, :requires_failed
        true
      else
        false
      end
    end

    def timeout
      nil # meaning use default timeout
    end

    def retry
      @tries += 1
      @visible_at += @retry_interval
      retriable?
    end

    def state
      @lock.synchronize { @state }
    end

    def trigger!(event)
      @lock.synchronize do
        s = case event
            when :skip
              :skipped
            when :start
              :running
            when :pend
              :pending
            when :complete
              :completed
            when :fail
              :failed
            when :requires_fail
              :requires_failed
            else
              raise Tumugi::TumugiError.new("Invalid event: #{event}")
            end

        if not AVAILABLE_STATES.include?(s)
          raise Tumugi::TumugiError.new("Invalid state: #{s}")
        end

        @state = s
      end
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

    def visible?(now)
      now >= @visible_at
    end

    def retriable?
      @tries <= @max_retry
    end
  end
end
