require 'time'

module Tumugi
  module Parameter
    class StringConverter
      def convert(value, opts={})
        value
      end
    end

    class IntegerConverter
      def convert(value, opts={})
        Integer(value)
      end
    end

    class FloatConverter
      def convert(value, opts={})
        Float(value)
      end
    end

    class BoolConverter
      def convert(value, opts={})
        if value =~ /^(true|false)$/
          value == 'true'
        else
          raise ArgumentError.new("Invalid value for Bool: '#{value}'")
        end
      end
    end

    class TimeConverter
      def convert(value, opts={})
        Time.parse(value)
      end
    end

    class Converter
      CONVERTERS = {
        string:  StringConverter.new,
        integer: IntegerConverter.new,
        float:   FloatConverter.new,
        bool:    BoolConverter.new,
        time:    TimeConverter.new,
      }

      def self.convert(type, value)
        converter = CONVERTERS[type]
        if converter
          converter.convert(value)
        else
          raise ArgumentError.new("Invalid type: #{type}")
        end
      end
    end
  end
end
