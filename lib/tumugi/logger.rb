require 'forwardable'
require 'json'
require 'logger'
require 'singleton'

module Tumugi
  class Logger
    include Singleton
    extend Forwardable
    def_delegators :@logger, :debug, :error, :fatal, :info, :warn, :level
    attr_accessor :job

    def initialize
      @formatters = {
        text: Proc.new{|severity, datetime, progname, msg| "#{datetime} #{severity} [#{job.id}] #{msg}\n" },
        json: Proc.new{|severity, datetime, progname, msg| "#{JSON.generate(time: datetime, severity: severity, job: job.id, message: msg)}\n" },
      }
      init
    end

    def init(output: STDOUT, format: :text)
      @logger = ::Logger.new(output)
      @logger.level = ::Logger::INFO
      @logger.formatter = @formatters[format]
    end

    def verbose!
      @logger.level = ::Logger::DEBUG
    end

    def quiet!
      @logger = ::Logger.new(nil)
    end
  end
end
