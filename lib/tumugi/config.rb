module Tumugi
  class ConfigError < StandardError
  end

  class Config
    attr_accessor :workers, :max_retry, :retry_interval, :param_auto_bind_enabled

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
          @section_procs[name].call(@section_instances[name])
        end
        @section_instances[name]
      end
    end
  end
end
