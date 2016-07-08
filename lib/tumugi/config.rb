require 'tumugi/error'

module Tumugi
  class Config
    attr_accessor :workers
    attr_accessor :max_retry
    attr_accessor :retry_interval
    attr_accessor :timeout

    @@sections ||= {}

    def self.register_section(name, *args)
      @@sections[name] = Struct.new(camelize(name), *args)
      logger.debug { "registered config section '#{name}' with '#{args}'" }
    end

    def self.camelize(term)
      string = term.to_s
      string = string.sub(/^[a-z\d]*/) { $&.capitalize }
      string.gsub!(/(?:_|(\/))([a-z\d]*)/) { $2.capitalize }
      string
    end

    def self.logger
      Tumugi::Logger.instance
    end

    def initialize
      @workers = 1
      @max_retry = 3
      @retry_interval = 300 #seconds
      @timeout = nil # meaning no timeout

      @section_procs = {}
      @section_instances = {}
    end

    def section(name, &block)
      if block_given?
        raise Tumugi::ConfigError.new('You cannot change section') if frozen?
        @section_procs[name] ||= block
        return nil
      end

      section_class = @@sections[name]
      if section_class.nil?
        raise ConfigError.new("Config section '#{name}' is not registered.")
      end

      if @section_instances[name].nil?
        @section_instances[name] = section_class.new
        begin
          @section_procs[name].call(@section_instances[name])
        rescue NoMethodError => e
          Config.logger.error "#{e.message}. Available attributes are #{@section_instances[name].members}"
          raise e
        end if @section_procs[name]
      end
      @section_instances[name].clone.freeze
    end
  end
end
