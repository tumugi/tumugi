require 'tumugi/parameter/converter'
require 'tumugi/parameter/error'

module Tumugi
  module Parameter
    class Parameter
      attr_accessor :name, :task_param_auto_bind_enabled, :application_param_auto_bind_enabled

      def initialize(name, opts={})
        @name = name
        @opts = opts
        @application_param_auto_bind_enabled = Tumugi.config.param_auto_bind_enabled
        @task_param_auto_bind_enabled = @application_param_auto_bind_enabled
        validate
      end

      def get
        if auto_bind?
          value = search_from_application_parameters
          value = search_from_env if value.nil?
        end

        return value unless value.nil?
        default_value
      end

      def auto_bind?
        if @opts[:auto_bind].nil?
          if @task_param_auto_bind_enabled
            true
          else
            false
          end
        else
          @opts[:auto_bind]
        end
      end

      def required?
        @opts[:required].nil? ? false : @opts[:required]
      end

      def type
        @opts[:type] || :string
      end

      def default_value
        @opts[:default] || nil
      end

      def merge_default_value(value)
        self.class.new(@name, @opts.merge(required: false, default: value))
      end

      private

      def search_from_application_parameters
        key = @name.to_s
        value = Tumugi.application.params[key]
        value ? Converter.convert(type, value) : nil
      end

      def search_from_env
        key = @name.to_s
        value = nil
        value = ENV[key] if ENV.has_key?(key)
        value = ENV[key.upcase] if ENV.has_key?(key.upcase)
        value ? Converter.convert(type, value) : nil
      end

      private

      def validate
        if required? && default_value != nil
          raise ParameterError.new("When you set required: true, you cannot set default value")
        end
      end
    end
  end
end
