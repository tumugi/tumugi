require 'tumugi/parameter/parameter'

module Tumugi
  module Parameter
    class ParameterProxy
      attr_accessor :name, :params, :param_defaults, :param_auto_bind_enabled

      def initialize(name)
        @name = name
        @params = {}
        @param_defaults = {}
      end

      def merge(other)
        merged = self.class.new(other.name)
        merged.params = other.params.merge(self.params)
        merged.param_defaults = other.param_defaults.merge(self.param_defaults)
        merged
      end

      def param(name, opts={})
        @params[name] = Tumugi::Parameter::Parameter.new(name, opts)
      end

      def set(name, value)
        @param_defaults[name] = value
      end

      def dump
        Marshal.dump(self)
      end
    end
  end
end
