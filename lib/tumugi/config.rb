require 'tumugi/error'

module Tumugi
  class Config
    attr_accessor :workers
    attr_accessor :max_retry
    attr_accessor :retry_interval
    attr_accessor :param_auto_bind_enabled
    attr_accessor :timeout

    @@sections ||= {}

    def self.register_section(name, *args)
      @@sections[name] = Struct.new(camelize(name), *args)
      Tumugi.logger.debug "registered config section '#{name}' with '#{args}'"
    end

    def self.camelize(term)
      string = term.to_s
      string = string.sub(/^[a-z\d]*/) { $&.capitalize }
      string.gsub!(/(?:_|(\/))([a-z\d]*)/) { $2.capitalize }
      string
    end

    def initialize
      @workers = 1
      @max_retry = 3
      @retry_interval = 300 #seconds
      @param_auto_bind_enabled = true
      @timeout = 0 # meaning no timeout

      @section_procs = {}
      @section_instances = {}
    end

    def section(name, &block)
      section_class = @@sections[name]
      if block_given?
        @section_procs[name] ||= block
      elsif section_class.nil?
        raise ConfigError, "Config section '#{name}' is not registered."
      else
        @section_instances[name] ||= section_class.new
        if @section_procs[name]
          begin
            @section_procs[name].call(@section_instances[name])
          rescue NoMethodError => e
            Tumugi.logger.error "#{e.message}. Available attributes are #{@section_instances[name].members}"
            raise e
          end
        end
        @section_instances[name]
      end
    end
  end
end
