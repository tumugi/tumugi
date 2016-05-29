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
          value = search_from_application_parameters
        end
        value.nil? ? default_value : value
      end

      def auto_bind?
        if @opts[:auto_bind].nil?
          false
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

      private

      def validate
        if required? && default_value != nil
          raise Tumugi::ParameterError.new("When you set required: true, you cannot set default value")
        end
      end
    end
  end
end
