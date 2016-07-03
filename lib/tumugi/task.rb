require 'tumugi/mixin/listable'
require 'tumugi/mixin/task_helper'
require 'tumugi/mixin/parameterizable'

require 'state_machines'

module Tumugi
  class Task
    include Tumugi::Mixin::Parameterizable
    include Tumugi::Mixin::Listable
    include Tumugi::Mixin::TaskHelper

    state_machine :state, initial: :pending do
      event :skip do
        transition pending: :skipped
      end

      event :start do
        transition pending: :running
      end

      event :pend do
        transition all => :pending
      end

      event :mark_completed do
        transition [:pending, :running] => :completed
      end

      event :mark_failed do
        transition [:pending, :running] => :failed
      end

      event :mark_requires_failed do
        transition [:pending, :running] => :requires_failed
      end

      state :completed, :skipped do
        def success?
          true
        end
      end

      state all - [:completed, :skipped] do
        def success?
          false
        end
      end

      state :completed, :skipped, :failed, :requires_failed do
        def finished?
          true
        end
      end

      state all - [:completed, :skipped, :failed, :requires_failed] do
        def finished?
          false
        end
      end
    end

    attr_reader :visible_at, :tries, :max_retry, :retry_interval

    def initialize
      super()
      @visible_at = Time.now
      @tries = 0
      @max_retry = Tumugi.config.max_retry
      @retry_interval = Tumugi.config.retry_interval
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
      list(_requires).any? { |t| t.instance.finish_failed? }
    end

    def finish_failed?
      finished? && !success?
    end

    def timeout
      nil # meaning use default timeout
    end

    def runnable?(now)
      ready? && visible?(now)
    end

    def retry(err)
      @tries += 1
      @visible_at += @retry_interval
      retriable?
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
