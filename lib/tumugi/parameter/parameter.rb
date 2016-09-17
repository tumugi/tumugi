require 'tumugi/error'
require 'tumugi/parameter/converter'

module Tumugi
  module Parameter
    class Parameter
      attr_accessor :name

      def initialize(name, opts={})
        @name = name
        @opts = opts
        validate
      end

      def get
        if auto_bind?
          value = search_from_workflow_parameters
        end
        value.nil? ? default_value : value
      end

      def auto_bind?
        option_as_bool(:auto_bind)
      end

      def required?
        option_as_bool(:required)
      end

      def type
        @opts[:type] || :string
      end

      def default_value
        @opts[:default].nil? ? nil : @opts[:default]
      end

      def merge_default_value(value)
        self.class.new(@name, @opts.merge(required: false, default: value))
      end

      def secure?
        option_as_bool(:secure)
      end

      private

      def search_from_workflow_parameters
        key = @name.to_s
        value = Tumugi.workflow.params[key]
        value ? Converter.convert(type, value) : nil
      end

      def validate
        if required? && !default_value.nil?
          raise Tumugi::ParameterError.new("When you set required: true, you cannot set default value")
        end
      end

      def option_as_bool(key)
        @opts[key].nil? ? false : @opts[key]
      end
    end
  end
end
