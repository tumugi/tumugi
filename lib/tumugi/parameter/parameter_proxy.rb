require 'tumugi/parameter/parameter'

module Tumugi
  module Parameter
    class ParameterProxy
      attr_accessor :name, :params

      def initialize(name)
        @name = name
        @params = {}
      end

      def merge(other)
        merged = self.class.new(other.name)
        merged.params = other.params.merge(self.params)
        merged
      end

      def param(name, opts={})
        @params[name] = Tumugi::Parameter::Parameter.new(name, opts)
      end

      def dump
        Marshal.dump(self)
      end
    end
  end
end
