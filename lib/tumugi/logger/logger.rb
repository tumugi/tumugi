require 'forwardable'
require 'json'
require 'logger'
require 'singleton'

module Tumugi
  class Logger
    include Singleton
    extend Forwardable
    def_delegators :@logger,  :debug, :debug?, :error, :error?,
                              :fatal, :fatal?, :info, :info?,
                              :warn, :warn?, :level
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
      Proc.new { |level, datetime, program_name, msg|
        "#{datetime} [#{level}]#{' (' + program_name + ')' unless program_name.nil?} #{msg}\n"
      }
    end

    def json_formatter
      Proc.new { |level, datetime, program_name, msg|
        hash = { time: datetime, level: level, message: msg }
        hash[:program_name] = program_name unless program_name.nil?
        hash[:workflow] = workflow_id unless workflow_id.nil?
        "#{JSON.generate(hash)}\n"
      }
    end
  end
end
