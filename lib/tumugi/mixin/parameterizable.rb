require 'tumugi/parameter/parameter_proxy'

module Tumugi
  module Mixin
    module Parameterizable
      def self.included(mod)
        mod.extend(ClassMethods)
      end

      def initialize
        super()
        proxy = self.class.merged_parameter_proxy
        proxy.params.each do |name, param|
          instance_variable_set("@#{name}", param.get)
        end
      end

      module ClassMethods
        def parameter_proxy_map
          map = {}
          self.define_singleton_method(:parameter_proxy_map) { map }
          map
        end

        def parameter_proxy(mod_name)
          map = parameter_proxy_map
          unless map[mod_name]
            proxy = Tumugi::Parameter::ParameterProxy.new(mod_name)
            map[mod_name] = proxy
          end
          map[mod_name]
        end

        def param(name, opts={})
          parameter_proxy(self.name).param(name, opts)
          attr_accessor name
        end

        def merged_parameter_proxy
          parameterizable = ancestors.reverse.select{ |a| a.respond_to?(:parameter_proxy) }
          parameterizable.map { |a| a.parameter_proxy(a.name || a.object_id.to_s) }.reduce(:merge)
        end

        def dump(level = 0)
          parameter_proxy_map[self.to_s].dump(level)
        end
      end
    end
  end
end

class << self
  def param(name, opts={})
    @params ||= {}
    @params[name.to_sym] = defaults.merge(opts)
    attr_accessor name.to_sym
  end

  def params
    @params
  end
end

def _bind_params(args)
  p self.class.params

  self.class.params.each do |name, opts|
    if opts[:auto_bind]
      _bind_from_args(args, name, opts)
    end
    if opts[:default] && send(name.to_sym).nil?
      send("#{name}=", opts[:deafult])
    end
  end
end

def _bind_from_args(args)
end

def configure
  # Do nothing. You can override in a subclass.
end
