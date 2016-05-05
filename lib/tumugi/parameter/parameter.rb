require 'tumugi/parameter/converter'

module Tumugi
  module Parameter
    class Parameter
      attr_accessor :name

      def initialize(name, opts={})
        @name = name
        @opts = opts
      end

      def get
        if auto_bind?
          value = search_from_env
          # TODO: implement find auto binding value
        end

        return value if value
        default_value
      end

      def auto_bind?
        @opts[:auto_bind].nil? ? true : @opts[:auto_bind]
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

      private

      def search_from_env
        key = @name.to_s
        value = nil
        value = ENV[key] if ENV.has_key?(key)
        value = ENV[key.upcase] if ENV.has_key?(key.upcase)
        value ? Converter.convert(type, value) : nil
      end
    end
  end
end
