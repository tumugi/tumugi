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
        text: text_formatter,
        json: json_formatter
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

    private

    def text_formatter
      Proc.new { |severity, datetime, progname, msg|
        if job.nil?
          "#{datetime} #{severity} #{msg}\n"
        else
          "#{datetime} #{severity} [#{job.id}] #{msg}\n"
        end
      }
    end

    def json_formatter
      Proc.new { |severity, datetime, progname, msg|
        hash = { time: datetime, severity: severity, message: msg }
        if not job.nil?
          hash[:job] = job.id
        end
        "#{JSON.generate(hash)}\n"
      }
    end
  end
end
