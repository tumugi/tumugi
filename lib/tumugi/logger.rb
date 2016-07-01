require 'forwardable'
require 'json'
require 'logger'
require 'singleton'

module Tumugi
  class Logger
    include Singleton
    extend Forwardable
    def_delegators :@logger, :debug, :error, :fatal, :info, :warn, :level
    attr_accessor :workflow_id

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
        if !workflow_id.nil?
          "#{datetime} #{severity} [#{workflow_id}] #{msg}\n"
        else
          "#{datetime} #{severity} #{msg}\n"
        end
      }
    end

    def json_formatter
      Proc.new { |severity, datetime, progname, msg|
        hash = { time: datetime, severity: severity, message: msg }
        if !workflow_id.nil?
          hash[:workflow] = workflow_id
        end
        "#{JSON.generate(hash)}\n"
      }
    end
  end
end
